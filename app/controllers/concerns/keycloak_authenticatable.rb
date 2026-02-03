module KeycloakAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_keycloak_user!
  end

  def authenticate_keycloak_user!
    token = extract_token
    Rails.logger.debug("Extracted Token: #{token}")

    unless token
      render json: { error: "No token provided" }, status: :unauthorized
      return
    end

    begin
      @current_user = decode_token(token)
      Rails.logger.debug("Authenticated User: #{@current_user}")
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT Decode Error: #{e.message}")
      render json: { error: "Invalid token" }, status: :unauthorized
    rescue StandardError => e
      Rails.logger.error("Authentication Error: #{e.message}")
            Rails.logger.error("Authentication Error: #{e}")
      render json: { error: "Authentication failed" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def current_user_roles
    @current_user&.dig("realm_access", "roles") || []
  end

  def has_role?(role)
    current_user_roles.include?(role)
  end

  private

  def extract_token
    header = request.headers["Authorization"]
    return nil unless header.present?

    # Extract token from "Bearer <token>"
    header.split(" ").last if header.start_with?("Bearer ")
  end

  def decode_token(token)
    public_key = KeycloakService.public_key
    config = Rails.application.config.keycloak
    issuer = config[:issuer] || KeycloakService.realm_url

    # Decode and verify the JWT
    decoded = JWT.decode(
      token,
      public_key,
      true,
      {
        algorithm: "RS256",
        verify_iss: true,
        iss: issuer,
        verify_aud: false  # Set to true and specify aud if needed
      }
    )

    decoded.first
  end
end
