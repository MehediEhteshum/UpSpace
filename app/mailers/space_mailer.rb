class SpaceMailer < ApplicationMailer

  def send_new_space_notification_to_admin(space)
    @space = space
    mail(to: ENV['ADMIN_EMAIL'], subject: "New Space Created")
  end

  def send_lister_welcome(space)
    @space = Space.find(space)
    @recipient = @space.user
    mail(to: @recipient.email, subject: "You've Published Your First Space - Now What?")
  end

end
