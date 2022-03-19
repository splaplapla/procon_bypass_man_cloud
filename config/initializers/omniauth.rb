Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV.fetch('GOOGLE_OAUTH2_CLIENT_ID'), ENV.fetch('GOOGLE_OAUTH2_SECRET')
end
