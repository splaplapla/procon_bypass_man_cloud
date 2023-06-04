class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :redirect_to_my_domain_from_heroku_domain

  def no_adsence_filter
    @no_ad = true
  end

  # NOTE: webはリダイレクトで対応できるけど、apiはherokuapp.comを参照し続けてしまう
  def redirect_to_my_domain_from_heroku_domain
    if request.domain.end_with?('herokuapp.com')
      redirect_to 'https://pbm-cloud.jiikko.com'
    end
  end
end
