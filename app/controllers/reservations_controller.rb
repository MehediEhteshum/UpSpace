class ReservationsController < ApplicationController
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!
  before_action :set_reservation, only: [:approve, :decline, :cancel, :show]
  before_action :is_authorised, only: [:show]

  def create
    space_id = params[:space_id]
    price_type = params[:price_type]
    space = Space.find(space_id)
    price = Price.find_by(space_id: space_id, price_type_id: price_type)
    is_dates_valid = reservation_params[:start_date].present? && reservation_params[:end_date].present?
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.space = space
    @reservation.price = price.price
    @reservation.price_type = price_type

    if is_dates_valid
      if price_type == "hourly"
        start_date = Time.parse(reservation_params[:start_date]).in_time_zone(current_user.time_zone)
        end_date = Time.parse(reservation_params[:end_date]).in_time_zone(current_user.time_zone)

        if end_date < start_date
          end_date_holder = start_date
          start_date = end_date
          end_date = end_date_holder

          @reservation.start_date = start_date.in_time_zone(current_user.time_zone)
          @reservation.end_date = end_date.in_time_zone(current_user.time_zone)
          @reservation.save!
        end

        # converting term from seconds to hours.
        term = (end_date - start_date).to_f / 60 / 60
      elsif price_type == "daily"
        start_date = Date.parse(reservation_params[:start_date]).in_time_zone(current_user.time_zone)
        end_date = Date.parse(reservation_params[:end_date]).in_time_zone(current_user.time_zone)

        if end_date < start_date
          end_date_holder = start_date
          start_date = end_date
          end_date = end_date_holder

          @reservation.start_date = start_date.in_time_zone(current_user.time_zone)
          @reservation.end_date = end_date.in_time_zone(current_user.time_zone)
          @reservation.save!
        end
        # converting term from seconds to days plus one missing day.
        term = ((end_date - start_date).to_f / 24 / 60 / 60) + 1
      end
      @reservation.term = term
      @reservation.total = (price.price * term).round(2)
      @reservation.Checkout!
      redirect_to checkout_path(reservation_id: @reservation.id)
      #   if @reservation.Waiting!
      #       ReservationMailer.send_request_to_guest(@reservation.user, space).deliver_later if @reservation.user.setting.enable_email
      #       ReservationMailer.send_request_to_host(@reservation.user, space).deliver_later if space.user.setting.enable_email
      #       flash[:notice] = "Request sent successfully!"
      #       redirect_to reservation_path(@reservation.id)
      #   else
      #     flash[:alert] = "Cannot make a reservation!"
      #     redirect_to space
      #   end

    elsif flash[:alert] = price_type == "hourly" ? "Please select a date" : "Please select a start date and end date"
      redirect_to space_path(space, :price_type => price_type) and return
    end
  end

  def show
    @status = @reservation.status
    @charge = Reservation.find(params[:id])
    if current_user.id == @charge.user_id
      respond_to do |format|
        format.pdf {
          send_data @charge.receipt.render,
            filename: "#{@charge.start_date.in_time_zone(current_user.time_zone).strftime("%Y-%m-%d")}-upspace-receipt.pdf",
            type: "application/pdf",
            disposition: :inline
        }
        format.html {
          render "show.html.erb"
        }
      end
    else
      redirect_to dashboard_path, alert: "You don't have permission to view this receipt."
    end
  end

  def your_trips
    @trips = current_user.reservations.reorder(start_date: :desc)
  end

  def bookings
    spaces = current_user.spaces.pluck(:id)
    @reservations = Reservation.where(
      "space_id IN (?) AND status >= ?",
      spaces, 0
    ).reorder(start_date: :desc)
  end

  def approve
    charge = Stripe::Charge.capture(@reservation.charge_id)
    @reservation.Approved!
    @reservation.captured_at = DateTime.now
    @reservation.save!
    ReservationMailer.send_confirmation_to_guest(@reservation.user, @reservation.space).deliver_later if @reservation.user.setting.enable_email
    ReservationMailer.send_confirmation_to_host(@reservation.user, @reservation.space).deliver_later if @reservation.space.user.setting.enable_email
    send_sms_to_host(@reservation.space, @reservation) if @reservation.space.user.setting.enable_sms && @reservation.space.user.phone_verified?
    send_sms_to_guest(@reservation.space, @reservation) if @reservation.user.setting.enable_sms && @reservation.user.phone_verified?
    flash[:notice] = "Request approved."
    redirect_to bookings_path
  rescue Stripe::CardError => e
    flash[:alert] = "There was an issue with the card authorization. Please try again."
    redirect_to bookings_path
  rescue => e
    flash[:alert] = e.message
    redirect_to bookings_path
  end

  def decline
    space = Space.find_by_id(@reservation.space_id)
    @reservation.Declined!
    ReservationMailer.send_decline_to_guest(@reservation.user, space).deliver_later if @reservation.user.setting.enable_email
    redirect_to bookings_path
  end

  def cancel
    if @reservation.status == "Approved"
      redirect_to request.referrer
      flash[:alert] = "This reservation cannot be cancelled because it has already been approved by the Host. Please email jenn@upspace.ca"
    elsif @reservation.status == "Declined"
      redirect_to request.referrer
      flash[:alert] = "This reservation cannot be cancelled because it has already been declined by the Host"
    elsif @reservation.status == "Waiting"
      @reservation.Cancelled!
      redirect_to request.referrer
      flash[:success] = "This reservation has been cancelled"
    end
  end

  private

  def send_sms_to_host(space, reservation)
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: Rails.application.secrets[:twilio][:number],
      to: space.user.phone_number,
      body: "#{reservation.user.fullname} requested your space'#{space.title}'",
    )
  end

  def send_sms_to_guest(space, reservation)
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: Rails.application.secrets[:twilio][:number],
      to: reservation.user.phone_number,
      body: "#{space.user.fullname} accepted your request for '#{space.title}'",
    )
  end

  def charge(space, reservation)
    if !reservation.user.stripe_id.blank?
      customer = Stripe::Customer.retrieve(reservation.user.stripe_id)
      charge = Stripe::Charge.create(
        :customer => customer.id,
        :amount => reservation.total * 100,
        :description => space.title,
        :currency => "cad",
        :destination => {
          :amount => reservation.total * 85, # 85% of the total amount goes to the Host
          :account => space.user.merchant_id, # Host's Stripe customer ID
        },
      )

      if charge
        reservation.Approved!
        ReservationMailer.send_confirmation_to_guest(@reservation.user, space).deliver_later if @reservation.user.setting.enable_email
        ReservationMailer.send_confirmation_to_host(@reservation.user, space).deliver_later if space.user.setting.enable_email
        send_sms_to_host(space, reservation) if space.user.setting.enable_sms && space.user.phone_verified?
        send_sms_to_guest(space, reservation) if reservation.user.setting.enable_sms && reservation.user.phone_verified?
        flash[:notice] = "Reservation created successfully!"
      else
        reservation.Declined!
        flash[:alert] = "Cannot charge with this payment method!"
      end
    end
  rescue Stripe::CardError => e
    flash[:alert] = "The credit card declined - the renter has been notified."
    ReservationMailer.send_card_error_to_guest(@reservation.user, space).deliver_later if @reservation.user.setting.enable_email
  rescue => e
    flash[:alert] = e.message
  end

  def is_authorised
    redirect_to root_path, alert: "You don't have permission." unless current_user.id == @reservation.user_id
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def verify_user_receipt
  end

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date)
  end
end
