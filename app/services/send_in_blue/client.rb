require 'uri'
require 'net/http'
require 'openssl'


module SendInBlue
  class Client
    class << self

      def addUser(email)
        url = URI("https://api.sendinblue.com/v3/contacts")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(url)
        request["accept"] = 'application/json'
        request["content-type"] = 'application/json'
        request["api-key"] = Rails.application.secrets[:send_in_blue][:api_key]
        request.body = '{"email":"' + email + '","listIds":[6],"updateEnabled":false}'
        response = http.request(request)
      end

      def addFeaturedRequest(email)
        url = URI("https://api.sendinblue.com/v3/contacts/lists/16/contacts/add")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(url)
        request["accept"] = 'application/json'
        request["content-type"] = 'application/json'
        request["api-key"] = Rails.application.secrets[:send_in_blue][:api_key]
        request.body = '{"emails":["' + email + '"]}'
        response = http.request(request)
        puts response.body
      end

    end
  end
end
