class OmniauthCallbacksController < ApplicationController
  before_action :has_streaming_service_filter, before: [:twitch, :google_oauth2]
  before_action :has_no_streaming_service_account_filter, before: [:twitch, :google_oauth2]

  def twitch
    create_streaming_service_account
    redirect_to(back_to, notice: "アカウントの連携ができました")
  end

  def google_oauth2
    create_streaming_service_account
    redirect_to(back_to, notice: "アカウントの連携ができました")
  end

  private

  def create_streaming_service_account
    current_streaming_service.create_streaming_service_account!(
      name: auth_hash.info.name,
      image_url: auth_hash.info.image,
      access_token: auth_hash.credentials.token,
      refresh_token: auth_hash.credentials.refresh_token,
      expires_at: Time.at(auth_hash.credentials.expires_at),
      uid: auth_hash.uid,
    )
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def back_to
    request.env['omniauth.origin'] || root_path
  end

  def current_streaming_service_id
    session[:current_streaming_service_id]
  end

  def current_streaming_service
    return @current_streaming_service if defined?(@current_streaming_service)
    return @current_streaming_service = current_user.streaming_services.find_by(id: current_streaming_service_id)
  end

  def has_streaming_service_filter
    raise "もう一度ログインしてください" unless current_streaming_service
  end

  def has_no_streaming_service_account_filter
    if current_streaming_service.streaming_service_account
      return redirect_to(back_to, notice: "このサービスではすでに連携済みです。")
    end
  end
end
