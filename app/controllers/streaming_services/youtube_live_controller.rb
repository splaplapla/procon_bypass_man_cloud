class StreamingServices::YoutubeLiveController < StreamingServices::Base
  before_action :reject_when_not_monitoring, only: [:commands]

  def new
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @my_channel_id, @live_stream = StreamingService::ShowAvailableLiveStreamService.new(@streaming_service_account).execute
  end

  def show
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @live_stream = StreamingService::ShowLiveStreamService.new(@streaming_service_account, video_id: params[:id]).execute
  rescue StreamingService::ShowLiveStreamService::AvailableVideoNotError => e
    render plain: e.message, status: :not_found
  end

  def commands
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    messages = StreamingService::FetchChatMessagesService.new(@streaming_service_account, video_id: params[:id]).execute
    result = StreamingService::ConvertMessagesToCommandsService.new(@streaming_service_account, messages: messages).execute
    render json: { commands: result, all: messages }
  end

  private

  def reject_when_not_monitoring
    if streaming_service_account.monitors_at.nil?
      return head :bad_request
    end
  end
end
