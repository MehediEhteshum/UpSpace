class UsersController < ApplicationController
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!, except: [:show, :created]
  before_action :set_last_payment_method, only: [:payment]

  def show
    @user = User.find(params[:id])
    @spaces = @user.spaces.where(active: true)

    # Display all the guest reviews to host (if this user is a host)
    @guest_reviews = Review.where(type: "GuestReview", host_id: @user.id)

    # Display all the host reviews to guest (if this user is a guest)
    @host_reviews = Review.where(type: "HostReview", guest_id: @user.id)
  end

  def update
    user = User.find(params[:id])
    user.update_attributes(user_params)
    redirect_to request.referrer
  end

  def assign_referral_code
    @user = User.find(params[:id])
    if @user.referral_code.nil?
      @user.referral_code = SecureRandom.hex(6)
      @user.save
      redirect_to request.referrer
    end
  end

  def update_phone_number
    current_user.update_attributes(user_params)
    current_user.generate_pin
    current_user.send_pin

    redirect_to edit_user_registration_path, notice: "Saved"
  rescue Exception => e
    redirect_to edit_user_registration_path, alert: "#{e.message}"
  end

  def verify_phone_number
    current_user.verify_pin(params[:user][:pin])

    if current_user.phone_verified
      flash[:notice] = "Your phone number is verified."
    else
      flash[:alert] = "Cannot verify your phone number."
    end

    redirect_to edit_user_registration_path
  rescue Exception => e
    redirect_to edit_user_registration_path, alert: "#{e.message}"
  end

  def payment
    @stripe_key = Rails.application.secrets[:stripe][:publishable_key]
  end

  def payout
    if !current_user.merchant_id.blank?
      account = Stripe::Account.retrieve(current_user.merchant_id)
      @login_link = "https://dashboard.stripe.com/login"
    end
  end

  def add_card
    if current_user.stripe_id.blank?
      customer = Stripe::Customer.create(
        email: current_user.email,
      )
      current_user.stripe_id = customer.id
      current_user.save
      # Add CC to Stripe
      customer.sources.create(source: params[:stripeToken])
    else
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

    flash[:notice] = "Your card is saved."
    UserMailer.send_card_notification_to_admin(current_user).deliver_later
    redirect_to payment_method_path
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to payment_method_path
  end

  def set_last_payment_method
    if !current_user.stripe_id.blank?
      customer = Stripe::Customer.retrieve(current_user.stripe_id)
      card = Stripe::Customer.retrieve_source(
        current_user.stripe_id,
        customer.default_source
      )
      @card_digits = card.last4
      @card_month = card.exp_month
      @card_year = card.exp_year
      @card_type = card.brand
    end
  end

  helper_method :last_card

  def created
    @user = current_user
  end

  def reminder_email
    user = User.find(params[:id])
    UserMailer.send_user_listing_reminder(user).deliver_later(wait_until: 24.hours.from_now)
    respond_to do |format|
      format.js { }
    end
  end

  def renter_info
    user = User.find(params[:id])
    UserMailer.send_rental_user_interest_to_admin(user, params[:info]).deliver_now
    respond_to do |format|
      format.js { }
    end
  end

  def confirmed
  end

  private

  def user_params
    params.require(:user).permit(:phone_number, :pin, :remember_card, :info)
  end
end
