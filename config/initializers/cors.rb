# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins "example.com"
#
#     resource "*",
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end

# Allowed origins can be set via the CORS_ORIGINS environment variable, which should be a comma-separated list of allowed origins. If not set, it defaults to allowing localhost on port 5173.
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    cors_origins = ENV.fetch("CORS_ORIGINS", "http://localhost:5173,http://127.0.0.1:5173")
                      .split(",")
                      .map(&:strip)
                      .reject(&:empty?)

    origins(*cors_origins)

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      expose: [ "Authorization" ]
  end
end
