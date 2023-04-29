class ApplicationController < ActionController::Base
  before_action :require_login

  def no_adsence_filter
    @no_ad = true
  end
end
