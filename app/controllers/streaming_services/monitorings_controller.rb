class StreamingServices::MonitoringsController < StreamingServices::Base
  def create
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @streaming_service_account.start_monitoring
    redirect_to(redirect_path, notice: "コメントとの連携を開始しました。")
  end

  def destroy
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @streaming_service_account.stop_monitoring
    redirect_to(redirect_path, notice: "コメントとの連携を停止しました。")
  end

  private

  def redirect_path
    if request.referrer.present?
      URI.parse(request.referrer).path
    else
      streaming_service_streaming_service_account_monitoring_path(@streaming_service, @streaming_service_account)
    end
  end
end
