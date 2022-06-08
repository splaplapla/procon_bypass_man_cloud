class OmniauthCallbacksController < ApplicationController
  def twitch
  end

  def google_oauth2
    if streaming_service = current_user.streaming_services.find_by(id: current_streaming_service_id)
      if streaming_service.streaming_service_account
        redirect_to(back_to, notice: "このサービスではすでに連携済みです。")
        return
      end

      streaming_service.create_streaming_service_account!(
        name: auth_hash.info.name,
        image_url: auth_hash.info.image,
        access_token: auth_hash.credentials.token,
        refresh_token: auth_hash.credentials.refresh_token,
        expires_at: Time.at(auth_hash.credentials.expires_at),
        uid: auth_hash.uid,
      )
    else
      raise "もう一度ログインしてください"
    end

    redirect_to(back_to, notice: "アカウントの連携ができました")
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def back_to
    request.env['omniauth.origin'] || root_path
  end

  def current_streaming_service_id
    session[:current_streaming_service_id]
  end
end
