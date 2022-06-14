class StreamingServices::TwitchController < StreamingServices::Base
  skip_forgery_protection only: :enqueue

  before_action :reject_when_not_monitoring, only: :enqueue

  def new
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    # TODO サービスクラスでラップする
    @live_stream = StreamingService::TwitchClient.new(@streaming_service_account).myself_live
  end

  def show
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    client = StreamingService::TwitchClient.new(@streaming_service_account)
    @live_stream = client.myself_live
    @twitch_my_user = client.myself
    @macro_trigger_table = macro_trigger_table
  end

  def enqueue
    if params[:word].blank?
      return render json: { errors: 'require word param' }, status: :bad_request
    end

    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    device = @streaming_service.device

    if(remote_macro = @streaming_service.remote_macro_group.remote_macros.tagged_with(params[:word], on: :trigger_words).first)
      remote_macro_job = RemoteMacro::CreatePbmRemoteMacroJobService.new(device: device).execute(steps: remote_macro.steps, name: remote_macro.name)
      ActionCable.server.broadcast(device.push_token, PbmRemoteMacroJobSerializer.new(remote_macro_job).attributes)
      return render json: {}, status: :ok
    end

    return render json: { errors: 'the remote_macro did not find' }, status: :bad_request
  end

  private

  def macro_trigger_table
    @streaming_service.
      remote_macro_group.
      remote_macros.
      flat_map { |x| x.trigger_word_list }.reduce({}) { |a, k| a[k] = true; a }
  end

  def reject_when_not_monitoring
    if streaming_service_account.monitors_at.nil?
      return head :bad_request
    end
  end
end
