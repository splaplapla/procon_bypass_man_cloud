class RemoteMacrosController < ApplicationController
  def new
    @remote_macro_group = current_user.remote_macro_groups.find(params[:remote_macro_group_id])
    @remote_macro = @remote_macro_group.remote_macros.build
  end

  def create
    @remote_macro_group = current_user.remote_macro_groups.find(params[:remote_macro_group_id])
    @remote_macro = @remote_macro_group.remote_macros.build(remote_macro_params)
    if @remote_macro.save
      redirect_to remote_macro_group_path(@remote_macro_group), notice: "リモートマクロの作成に成功しました"
    else
      render :new
    end
  end

  private

  def remote_macro_params
    params.require(:remote_macro).permit(:name, :steps)
  end
end
