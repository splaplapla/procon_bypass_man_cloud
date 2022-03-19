class Api::StreamingServices::RemoteMacroCommandsController < Api::Base
  def enqueue
    device = get_device
    if remote_macro = device.user.remote_macros.tagged_with(params[:word], on: :trigger_words).first
      remote_macro_job = RemoteMacro::CreatePbmRemoteMacroJobService.new(device: device).execute(steps: remote_macro.steps, name: remote_macro.name)
      ActionCable.server.broadcast(device.push_token, PbmRemoteMacroJobSerializer.new(remote_macro_job).attributes)
      return render json: {}, status: :ok
    end

    render json: { errors: 'the remote_macro_command did not find' }, status: :bad_request
  end
end
