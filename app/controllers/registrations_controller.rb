class RegistrationsController < Devise::RegistrationsController
  def build_resource(hash = {})
    super

    if cookies[:referral_code] && referrer = User.find_by(referral_code: cookies[:referral_code])
      self.resource.referred_by = referrer
    end

    signup = SendInBlue::Client.addUser(params[:user][:email])
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

end
