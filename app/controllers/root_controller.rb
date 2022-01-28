class RootController < ApplicationController
  skip_before_action :require_login

  def index
    if current_user
      redirect_to devices_url
    end
  end
end
