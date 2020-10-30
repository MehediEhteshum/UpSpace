Twilio.configure do |config|
  config.account_sid = Rails.application.secrets[:twilio][:sid]
  config.auth_token = Rails.application.secrets[:twilio][:token]
end
