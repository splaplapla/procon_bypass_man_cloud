class Api::StreamingServices::PbmRemoteMacroJobsController < Api::Base
  def enqueue
    device = get_device
    unless(streaming_service = device.user.streaming_services.find_by(streaming_services: { unique_key: params[:streaming_service_id] }))
      return render json: { errors: 'the streaming_service did not find' }, status: :bad_request
    end

    if(remote_macro = streaming_service.remote_macro_group.remote_macros.tagged_with(params[:word], on: :trigger_words).first)
      remote_macro_job = RemoteMacro::CreatePbmRemoteMacroJobService.new(device: device).execute(steps: remote_macro.steps, name: remote_macro.name)
      ActionCable.server.broadcast(device.push_token, PbmRemoteMacroJobSerializer.new(remote_macro_job).attributes)
      return render json: {}, status: :ok
    end

    render json: { errors: 'the remote_macro did not find' }, status: :bad_request
  end
end
