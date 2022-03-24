class StreamingService::ConvertMessagesToCommandsService
  # @param [Array<StreamingService::YoutubeLive::ChatMessage>] messages
  def initialize(streaming_service_account, messages: )
    @streaming_service_account = streaming_service_account
    @messages = messages
  end

  # TODO ここでmessagesをコマンドに変換する
  def execute
    result = []
    @messages.each_slice(100) do |chunk_messages|
      messages = chunk_messages.select do |message|
        reject_outdated(message) && is_command?(message) && is_normal_author?(message)
      end

      result << trigger(is_triggerable?(messages))
    end

    result.flatten
  end

  private

  def reject_outdated(message)
    raise("おかしい") if @streaming_service_account.monitors_at.nil?
    message.published_at > @streaming_service_account.monitors_at
  end

  # not banded, not moderator
  def is_normal_author?(message)
    !message.moderator
  end

  # プレフィックスが一致しているもののみを絞る
  def is_command?(message)
    /^!/ =~ message.body
  end

  # 一致するトリガーワードで検索する
  def is_triggerable?(messages)
    remote_macros = @streaming_service_account.streaming_service.remote_macro_group.remote_macros.tagged_with(messages.map { |x| x.to_trigger_word }, on: :trigger_words)
    command_table = remote_macros.flat_map(&:trigger_word_list).index_by { |x| "!#{x}" }
    messages.select { |x| command_table[x.body] }
  end

  def trigger(messages)
    messages.each do |message|
      if remote_macro = @streaming_service_account.streaming_service.remote_macro_group.remote_macros.tagged_with(message.to_trigger_word, on: :trigger_words).first
        remote_macro_job = RemoteMacro::CreatePbmRemoteMacroJobService.new(device: device).execute(steps: remote_macro.steps, name: remote_macro.name)
        ActionCable.server.broadcast(device.push_token, PbmRemoteMacroJobSerializer.new(remote_macro_job).attributes)
      end
    end
  end

  def streaming_service
    @streaming_service_account.streaming_service
  end

  def device
    @streaming_service_account.streaming_service.device
  end
end
