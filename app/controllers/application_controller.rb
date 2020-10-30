class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_referral_cookie
  before_action :masquerade_user!

  around_action :set_time_zone, if: :current_user

  protected

  def after_sign_in_path_for(resource_or_scope)
    current_user.sign_in_count > 1 ? stored_location_for(resource_or_scope) : new_user_created_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname, :found_us, :terms_agreement, :phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fullname, :found_us, :phone_number, :description])
  end

  def set_referral_cookie
    if params[:ref]
      cookies[:referral_code] = {
        value: params[:ref],
        expires: 30.days.from_now,
      }
    end
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
