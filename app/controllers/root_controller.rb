class RootController < ApplicationController
  skip_before_action :require_login

  before_action :no_adsence_filter, only: :index

  def index
    if current_user
      redirect_to devices_url
    end
  end
end
