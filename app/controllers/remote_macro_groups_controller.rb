class RemoteMacroGroupsController < ApplicationController
  def index
    @remote_macro_groups = RemoteMacroGroup.all
  end

  def new
    @remote_macro_group = current_user.remote_macro_groups.build
  end

  def create
    @remote_macro_group = current_user.remote_macro_groups.build(remote_macro_group_param)
    if @remote_macro_group.save
      redirect_to remote_macro_group_path(@remote_macro_group), notice: "新規作成に成功しました"
    else
      render :new
    end
  end

  def show
  end

  private

  def remote_macro_group_param
    params.require(:remote_macro_group).permit(:name)
  end
end
