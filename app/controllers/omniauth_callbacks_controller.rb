class OmniauthCallbacksController < ApplicationController
  def create
    StreamingServiceAccount.find_by(uid: auth_hash.uid)&.destroy

    if streaming_service = current_user.streaming_services.find_by(id: session[:current_streaming_service_id])
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

    redirect_to(back_to, notice: "アカウントの連携ができました")  || root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def back_to
    request.env['omniauth.origin']
  end
end
