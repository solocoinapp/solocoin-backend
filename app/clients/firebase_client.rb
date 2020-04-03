require 'singleton'

module Clients
  class FirebaseClient
    include Singleton

    URLS = {
      get_info: "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=#{ENV['firebase_admin_api_key']}"
    }.freeze

    def info_exists?(token, country_code, mobile)
      response = HTTParty.post(
        URLS[:get_info],
        body: { idToken: token }
      )

      if success?(response, country_code, mobile)
        true
      else
        Rails.logger.error("Firebase idToken verification failed. body: #{response}, status: #{response.code}, token: #{token}, mobile: #{mobile}")
        false
      end
    end

    private

    def success?(response, country_code, mobile)
      response.success? &&
        Array(response['users']).any? &&
        response['users'].first['phoneNumber'] == "#{country_code}#{mobile}"
    end
  end
end
