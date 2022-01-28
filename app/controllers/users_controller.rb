class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(params.require(:user).permit(:email))
      redirect_to edit_user_path, notice: "更新に成功しました"
    else
      render :edit
    end
  end

  def create
  end
end
