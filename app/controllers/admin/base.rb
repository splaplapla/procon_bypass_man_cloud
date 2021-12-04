class Admin::Base < ActionController::Base
  layout 'admin'

  before_action :require_admin_user

  private

  def require_admin_user
    redirect_to root_url unless current_user&.admin
  end
end
