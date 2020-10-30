class SpacesController < ApplicationController
  before_action :set_space, except: [:index, :new, :create, :add_card, :send_email, :checkout, :use_default_card, :details, :details_update, :reservation_review, :reservation_complete]
  before_action :set_reservation, :is_authorized_reservation, only: [:checkout, :add_card, :use_default_card, :details, :details_update, :reservation_review, :reservation_complete]
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorised, only: [:listing, :pricing, :description, :photo_upload, :amenities, :location, :update]
  before_action :is_published, only: [:show]

  def index
    @spaces = current_user.spaces
  end

  def new
    @space = current_user.spaces.build
  end

  def create
    @space = current_user.spaces.build(space_params)
    if @space.save
      active_price_types = [1, 2]
      active_price_types.each do |type|
        @space.prices.create(price_type_id: type, active: false)
      end
      redirect_to save_refresh, notice: "Saved."
      SpaceMailer.send_new_space_notification_to_admin(@space).deliver_later
    else
      flash[:alert] = "All fields are required."
      render :new
    end
  end

  def show
    @photos = @space.photos.order(:sort)
    @guest_reviews = @space.guest_reviews
    @tour_embed = @space.tour_embed
    @video_embed = @space.video_embed
    @prices = Price.where("space_id = ? AND active = ?", params[:id], true)

    @modal_date_options = {day: "numeric", weekday: "short", year: "numeric", month: "short"} if @space.listing_type == "Hourly"
    @modal_date_options = {minute: "numeric", hour: "numeric", day: "numeric", weekday: "short", year: "numeric", month: "short"} if @space.listing_type == "Daily"

    @stripe_key = Rails.application.secrets[:stripe][:publishable_key]
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
    @photos = @space.photos.order(:sort)
  end

  def amenities
  end

  def location
  end

  def payout
    @login_link = "https://dashboard.stripe.com/login"
  end

  def update
    if @space.update(space_params)
      flash[:notice] = "Saved."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_to save_refresh
  end

  # def publish
  #   if is_ready_space
  #     @space.active = true
  #     flash[:notice] = "Published"
  #   else
  #     flash[:alert] = "Not published. Make sure all fields are completed."
  #   end
  # end

  def destroy
    @space = Space.find(params[:id])
    @space.destroy

    redirect_back(fallback_location: request.referer, notice: "Listing deleted.")
  end

  # --- Reservations ---
  def preload
    today = Date.today
    reservations = @space.reservations.where("(start_date >= ? OR end_date >= ?) AND status = ?", today, today, 1)
    unavailable_dates = @space.calendars.where("status = ? AND day > ?", 1, today)

    special_dates = @space.calendars.where("status = ? AND day > ? AND price <> ?", 0, today, @space.price)

    render json: {
      reservations: reservations,
      unavailable_dates: unavailable_dates,
      special_dates: special_dates,
    }
  end

  def preview
    start_date = Time.parse(params[:start_date])
    end_date = Time.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date, @space),
    }

    render json: output
  end

  def checkout
    @space = Space.find(@reservation.space_id)
    customer = Stripe::Customer.retrieve(current_user.stripe_id) if !current_user.stripe_id.blank?
    @stripe_card = Stripe::Customer.retrieve_source(current_user.stripe_id, customer.default_source) if !current_user.stripe_id.blank?
    @stripe_key = Rails.application.secrets[:stripe][:publishable_key]
  end

  def details
    @space = Space.find(@reservation.space_id)
  end

  def details_update
    @reservation.update(reservation_params)
    redirect_to reservation_review_path
  end

  def reservation_review
    @space = Space.find(@reservation.space_id)
    @stripe_card = Stripe::Customer.retrieve_source(current_user.stripe_id, @reservation.source_id)
  end

  def reservation_complete
    reservation = Reservation.find(params[:reservation_id])
    if reservation.source_id.blank?
      flash[:alert] = "You need to set a payment method"
      redirect_to checkout_path(reservation.id)
    end
    if reservation.charge_id.blank?
      reservation.charge_id = authorize_charge(reservation)
      reservation.authorized_at = DateTime.now
      reservation.Waiting!
      ReservationMailer.send_request_to_guest(reservation.user, reservation.space).deliver_later if reservation.user.setting.enable_email
      ReservationMailer.send_request_to_host(reservation.user, reservation.space, reservation.description).deliver_later if reservation.space.user.setting.enable_email
      # ReservationMailer.send_confirmation_to_guest(@reservation.user, space).deliver_later if @reservation.user.setting.enable_email
      # ReservationMailer.send_confirmation_to_host(@reservation.user, space).deliver_later if space.user.setting.enable_email
      # send_sms_to_host(space, reservation) if space.user.setting.enable_sms && space.user.phone_verified?
      # send_sms_to_guest(space, reservation) if reservation.user.setting.enable_sms && reservation.user.phone_verified?
      # flash[:notice] = "Reservation created successfully!"
    end
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to checkout_path(reservation.id)
  rescue => e
    flash[:alert] = e.message
    redirect_to checkout_path(reservation.id)
  end

  def add_card
    if current_user.stripe_id.blank?
      new_customer = true
      customer = Stripe::Customer.create(
        email: current_user.email,
      )
      current_user.stripe_id = customer.id
      current_user.save
      # Add CC to Stripe
      customer.sources.create(source: params[:stripeToken])
    else
      new_customer = false
      customer = Stripe::Customer.retrieve(current_user.stripe_id)
      customer.sources.create(source: params[:stripeToken])
      # Set the new card as the default payment method
      new_card = Stripe::Token.retrieve(params[:stripeToken])["card"]["id"]
      Stripe::Customer.update(
        current_user.stripe_id,
        {
          default_source: new_card,
        }
      )
      customer.save
    end

    if new_customer == true
      @reservation.source_id = Stripe::Customer.retrieve_source(current_user.stripe_id, customer.default_source).data[0]["id"]
    else
      @reservation.source_id = Stripe::Customer.retrieve_source(current_user.stripe_id, customer.default_source).id
    end
    @reservation.save
    redirect_to details_path
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to request.referrer
  end

  def use_default_card
    customer = customer = Stripe::Customer.retrieve(current_user.stripe_id)
    @reservation.source_id = Stripe::Customer.retrieve_source(current_user.stripe_id, customer.default_source).id
    @reservation.save
    redirect_to details_path
  end

  private

  def is_conflict(start_date, end_date, space)
    check = space.reservations.where("(? < start_date AND end_date < ?) AND status = ?", start_date, end_date, 1)
    check_2 = space.calendars.where("day BETWEEN ? AND ? AND status = ?", start_date, end_date, 1).limit(1)

    check.size > 0 || check_2.size > 0 ? true : false
  end

  def set_space
    @space = Space.find(params[:id])
  end

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
  end

  def authorize_charge(reservation)
    if !reservation.user.stripe_id.blank?
      customer = Stripe::Customer.retrieve(reservation.user.stripe_id)
      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: (reservation.total.to_f * 100).round(0).to_i,
        description: reservation.space.title,
        currency: "cad",
        destination: {
          amount: (reservation.total.to_f * 85).round(0).to_i, # 85% of the total amount goes to the Host
          account: reservation.space.user.merchant_id, # Host's Stripe customer ID
        },
        capture: false,
      )
      return charge.id
    end
  rescue => e
    flash[:alert] = e.message
    redirect_to checkout_path(reservation.id)
  end

  def is_authorized_reservation
    redirect_to root_path, alert: "You don't have permission." unless current_user.id == @reservation.user_id
  rescue NoMethodError => e
    redirect_to root_path, alert: "You must be logged in."
  end

  def save_refresh
    if @space.active?
      request.referrer
    elsif @space.title.blank? || @space.description.blank?
      description_space_path(@space)
    elsif @space.photos.blank?
      photo_upload_space_path(@space)
    elsif !@space.has_active_price
      pricing_space_path(@space)
    elsif @space.longitude.blank?
      location_space_path(@space)
    elsif !current_user.is_active_host
      payout_space_path(@space)
    else request.referrer     end
  end

  def is_authorised
    redirect_to root_path, alert: "You don't have permission." unless current_user.id == @space.user_id
  end

  def is_published
    redirect_to root_path, alert: "This space is not currently available." unless ((@space.active?) || (user_signed_in? && current_user.id == @space.user_id))
  end

  def is_ready_space
    current_user.is_active_host && !@space.active && @space.has_active_price && !@space.title.blank? && !@space.photos.blank? && !@space.address.blank? && !@space.latitude.blank? && !@space.longitude.blank?
  end

  def space_params
    params.require(:space).permit(:title, :listing_type, :listing_category, :price,
                                  :description, :capacity, :address, :sqft, :is_wifi, :is_food, :is_accessible,
                                  :is_audio, :is_video, :is_alcohol, :is_byob, :is_ground, :is_catering,
                                  :is_natural, :is_kitchen, :parking, :active, :instant, :video_embed, :tour_embed,
                                  :availability_text, prices_attributes: [:id, :price, :price_type_id, :space_id, :active])
  end

  def reservation_params
    params.require(:reservation).permit(:reservation_id, :description)
  end

  def has_price_type
    params[:price_type].present?
  end

  helper_method :has_price_type

  def price_type
    params[:price_type]
  end

  helper_method :price_type
end
