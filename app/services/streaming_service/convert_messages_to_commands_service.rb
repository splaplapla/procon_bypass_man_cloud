class StreamingService::ConvertMessagesToCommandsService
  def initialize(streaming_service_account, messages: )
    @streaming_service_account = streaming_service_account
    @messages = messages
  end

  # TODO ここでmessagesをコマンドに変換する
  def execute
  end
end
