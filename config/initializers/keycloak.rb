Rails.application.config.keycloak = {
  realm: ENV.fetch("KEYCLOAK_REALM", "credit"),
  auth_server_url: ENV.fetch("KEYCLOAK_URL", "http://localhost:8080"),
  client_id: ENV.fetch("KEYCLOAK_CLIENT_ID", "credit-api")
}
