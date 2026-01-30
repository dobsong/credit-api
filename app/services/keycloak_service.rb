require "net/http"
require "json"

class KeycloakService
  class << self
    def public_key
      @public_key ||= fetch_public_key
    end

    def realm_url
      config = Rails.application.config.keycloak
      "#{config[:auth_server_url]}/realms/#{config[:realm]}"
    end

    private

    def fetch_public_key
      uri = URI("#{realm_url}/protocol/openid-connect/certs")
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        certs = JSON.parse(response.body)
        # Get the first key with alg of RS256. This obviously assumes Keycloak has a single public RS256 key for the realm, which it normally should
        key_data = certs["keys"].find { |key| key["alg"] == "RS256" }

        raise "No RS256 key found in Keycloak certs at #{realm_url}/protocol/openid-connect/certs" unless key_data

        # Convert JWK to PEM format
        jwk = JWT::JWK.import(key_data)
        jwk.public_key
      else
        raise "Failed to fetch Keycloak public key: #{response.code}"
      end
    rescue StandardError => e
      Rails.logger.error("Keycloak public key fetch error: #{e.message}")
      raise
    end

    def refresh_public_key
      @public_key = nil
      public_key
    end
  end
end
