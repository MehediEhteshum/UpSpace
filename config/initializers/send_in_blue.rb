require 'sib-api-v3-sdk'

SibApiV3Sdk.configure do |config|
  config.api_key['api-key'] = Rails.application.secrets[:send_in_blue][:api_key]
end
