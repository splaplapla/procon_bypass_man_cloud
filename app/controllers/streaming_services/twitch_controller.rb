class StreamingServices::TwitchController < StreamingServices::Base
  def new
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
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

  private

  def macro_trigger_table
    @streaming_service.
      remote_macro_group.
      remote_macros.
      flat_map { |x| x.trigger_word_list }.reduce({}) { |a, k| a[k] = true; a }
  end
end
