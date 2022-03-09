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

  def destroy
    remote_macro = current_user.remote_macros.find(params[:id])
    remote_macro_group = remote_macro.remote_macro_group
    remote_macro.destroy
    redirect_to remote_macro_group_path(remote_macro_group), notice: "リモートマクロの削除に成功しました"
  end

  def test_emit
    remote_macro = current_user.remote_macros.find(params[:remote_macro_id])
    device = current_user.devices.find_by!(unique_key: params[:device_unique_key])

    remote_macro_job = RemoteMacro::CreatePbmRemoteMacroJobService.new(device: device).execute(steps: remote_macro.steps, name: remote_macro.name)
    # ActionCable.server.broadcast(device.push_token, RemoteMacroJobSerializer.new(remote_macro_job).attributes)
    redirect_to remote_macro_group_path(remote_macro.remote_macro_group), notice: "テスト実行を行いました"
  end

  private

  def remote_macro_params
    params.require(:remote_macro).permit(:name, :steps)
  end
end
