class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def stripe_connect
    auth_data = request.env["omniauth.auth"]

    @user = current_user

    if @user.persisted?
      @user.merchant_id = auth_data.uid
      @user.save!
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Stripe account connected successfully." if is_navigational_format?
      OmniauthCallbacksMailer.send_notification_to_admin(@user).deliver_later
    else
      session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
      if @user.spaces.count == 1
        redirect_to payout_space_path(@user.spaces.first.id)
      else
        redirect_to dashboard_path
      end
    end
  end

  def failure
    redirect_to root_path
  end
end
