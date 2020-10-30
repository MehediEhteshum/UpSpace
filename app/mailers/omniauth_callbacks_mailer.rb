class OmniauthCallbacksMailer < ApplicationMailer

  def send_notification_to_admin(user)
    @user = user
    mail(to: ENV['ADMIN_EMAIL'], subject: "User Stripe Account Linked")
  end

end
