class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  before_action :no_adsence_filter, only: :new

  def new
  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to(:devices, notice: 'Login successful')
    else
      flash.now[:alert] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    redirect_to(root_path, notice: 'ログアウトしました')
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
