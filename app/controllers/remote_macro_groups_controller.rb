class RemoteMacroGroupsController < ApplicationController
  def index
    @remote_macro_groups = RemoteMacroGroup.all
  end

  def new
    @remote_macro_group = current_user.remote_macro_groups.build
  end

  def create
    @remote_macro_group = current_user.remote_macro_groups.build(remote_macro_group_params)
    if @remote_macro_group.save
      redirect_to remote_macro_group_path(@remote_macro_group), notice: "新規作成に成功しました"
    else
      render :new
    end
  end

  def show
    @remote_macro_group = current_user.remote_macro_groups.find(params[:id])
    @remote_macros = @remote_macro_group.remote_macros
  end

  def destroy
    remote_macro_group = current_user.remote_macro_groups.find(params[:id])
    remote_macro_group.destroy
    redirect_to remote_macro_groups_path, notice: "削除に成功しました"
  end

  private

  def remote_macro_group_params
    params.require(:remote_macro_group).permit(:name, :steps, :memo)
  end
end
