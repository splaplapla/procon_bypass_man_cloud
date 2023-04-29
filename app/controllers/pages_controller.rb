class PagesController < ApplicationController
  skip_before_action :require_login

  def terms
  end

  def faq
  end

  def ads
    render plain: 'google.com, pub-7975732944857239, DIRECT, f08c47fec0942fa0'
  end
end
