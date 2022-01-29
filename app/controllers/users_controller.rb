class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :redirect_if_has_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(params.require(:user).permit(:email))
      redirect_to edit_user_path, notice: "更新できました"
    else
      render :edit
    end
  end

  def create
    @user = User.new(params.require(:user).permit(:email, :password, :password_confirmation))
    if @user.save
      auto_login(@user)
      redirect_to devices_path, notice: "登録ができました"
    else
      render :new
    end
  end

  private

  def redirect_if_has_user
    redirect_to devices_path if current_user
  end
end
