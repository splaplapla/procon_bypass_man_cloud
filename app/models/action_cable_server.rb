class ActionCableServer
  DEFAULT_PATH = '/websocket'

  def initialize(action_cable_url: ENV.fetch('ACTION_CABLE_URL', nil))
    @action_cable_url = action_cable_url
  end

  # @return [String]
  # NOTE: 設定ファイルから使われていて、同じホスト名ならホスト名を省略できる
  def url
    @action_cable_url.presence || DEFAULT_PATH
  end

  # @return [String]
  # NOTE: APIから使われていて、同じホスト名であってもホスト名を省略できない
  # NOTE: 引数hostよりも@action_cable_urlが優先される
  def url_with_host(host: )
    return url if url.start_with?('ws:')

    if @action_cable_url.blank?
      "ws://#{File.join(host, DEFAULT_PATH)}"
    else
      "ws://#{url}"
    end
  end
end
