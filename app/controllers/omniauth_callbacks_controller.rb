class OmniauthCallbacksController < ApplicationController
  def create
    binding.pry
    auth_hash.info.email
    Rails.logger.debug auth_hash
    redirect_to request.env['omniauth.origin'] || root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
