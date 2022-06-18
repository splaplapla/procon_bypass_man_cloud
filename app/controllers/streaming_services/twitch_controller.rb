class StreamingServices::TwitchController < StreamingServices::Base
  skip_forgery_protection only: :enqueue

  before_action :require_word_param, only: :enqueue
  before_action :reject_when_not_monitoring, only: :enqueue
  before_action :require_streaming_service_device, only: :enqueue
  before_action :require_streaming_service_remote_macro_group, only: :enqueue

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
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    device = @streaming_service.device

    unless(remote_macro = @streaming_service.remote_macro_group.remote_macros.tagged_with(params[:word], on: :trigger_words).first)
      return render json: { errors: 'The remote_macro did not find' }, status: :bad_request
    end

    remote_macro_job = RemoteMacro::CreatePbmRemoteMacroJobService.new(device: device).execute(steps: remote_macro.steps, name: remote_macro.name)
    ActionCable.server.broadcast(device.push_token, PbmRemoteMacroJobSerializer.new(remote_macro_job).attributes)
    return render json: {}, status: :ok
  end

  private

  def macro_trigger_table
    @streaming_service.
      remote_macro_group.
      remote_macros.
      flat_map { |x| x.trigger_word_list }.reduce({}) { |a, k| a[k] = true; a }
  end

  def require_word_param
    if params[:word].blank?
      return render json: { errors: 'Require word param' }, status: :bad_request
    end
  end

  def reject_when_not_monitoring
    if streaming_service_account.monitors_at.nil?
      return head :bad_request
    end
  end

  def require_streaming_service_device
    if streaming_service.device.nil?
      return render json: { errors: 'Require device of streaming_service' }, status: :bad_request
    end
  end

  def require_streaming_service_remote_macro_group
    if streaming_service.remote_macro_group.nil?
      return render json: { errors: 'Require remote_macro_group of streaming_service' }, status: :bad_request
    end
  end
end
