Rails.application.config.keycloak = {
  realm: ENV.fetch("KEYCLOAK_REALM", "credit"),
  auth_server_url: ENV.fetch("KEYCLOAK_URL", "http://localhost:8080")
}
