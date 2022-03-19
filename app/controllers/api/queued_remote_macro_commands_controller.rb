class Api::QueuedRemoteMacroCommandsController < Api::Base
  def create
    device = get_device
    if device.remote_macro_commands.tagged_with(trigger_word: params[:word]).first
      remote_macro = remote_macro_command.remote_macro
      remote_macro_job = RemoteMacro::CreatePbmRemoteMacroJobService.new(device: device).execute(steps: remote_macro.steps, name: remote_macro.name)
      ActionCable.server.broadcast(device.push_token, PbmRemoteMacroJobSerializer.new(remote_macro_job).attributes)
      return
    end

    render json: { errors: 'the remote_macro_command did not find' }, status: :bad_request
  end
end
