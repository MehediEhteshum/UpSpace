class UserMailer < ApplicationMailer
  def send_card_notification_to_admin(user)
    @user = user
    mail(to: ENV["ADMIN_EMAIL"], subject: "User Credit Card Added")
  end

  def send_user_notification_to_admin(user)
    @user = user
    mail(to: ENV["ADMIN_EMAIL"], subject: "New upSpace User")
  end

  def send_welcome_to_user(user)
    @recipient = user
    mail(
      to: @recipient.email,
      reply_to: "hello@upspace.ca",
      subject: "upSpace Account Confirmation",
    )
  end

  def send_user_listing_reminder(user)
    @user = user
    mail(
      to: user.email,
      subject: "Your Personal Reminder to Complete your Listing",
    )
  end

  def send_rental_user_interest_to_admin(user, info)
    @user = user
    @info = info
    mail(
      to: ENV["ADMIN_EMAIL"],
      subject: "New Rental User Info",
    )
  end
end
