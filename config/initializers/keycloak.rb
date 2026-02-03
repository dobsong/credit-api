Rails.application.config.keycloak = {
  realm: ENV.fetch("KEYCLOAK_REALM", "credit"),
  auth_server_url: ENV.fetch("KEYCLOAK_URL", "http://localhost:8080"),
  issuer: ENV["KEYCLOAK_ISSUER"] # default "#{auth_server_url}/realms/#{realm}" will be used if expected issuer is not explicitly set
}
