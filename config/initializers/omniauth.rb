Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_OAUTH2_CLIENT_ID"], ENV['GOOGLE_OAUTH2_SECRET'], {
    scope: 'userinfo.email, userinfo.profile, http://gdata.youtube.com',
    prompt: 'consent',
    image_aspect_ratio: 'square',
    image_size: 50
  }

  provider :twitch, ENV["TWITCH_OAUTH2_CLIENT_ID"],  ENV['TWITCH_OAUTH2_SECRET'], {
    scope: 'user:read:email chat:read chat:edit',
  }
end
