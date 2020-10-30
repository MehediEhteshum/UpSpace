class MessageMailer < ApplicationMailer

  def send_message_to_recipient(recipient, sender, message)
    @recipient = recipient
    @context = message.context
    @sender = sender
    mail(to: @recipient.email, bcc: ENV['ADMIN_EMAIL'], subject: "New upSpace Message")
  end

end
