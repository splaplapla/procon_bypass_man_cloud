class Event < ApplicationRecord
  serialize :body, JSON

  EVENT_TYPE = {
    boot: { value: 0, label: '起動完了', body_visibility: false },
    reload_config: { value: 10, label: '設定ファイルの再読み込み完了', body_visibility: false },
    load_config: { value: 20, label: '設定ファイルの読み込み完了', body_visibility: false },
    heartbeat: { value: 30, label: nil, body_visibility: false },
    info: { value: 35, label: '情報', body_visibility: true },
    error: { value: 40, label: 'エラー', body_visibility: true },
    warn: { value: 45, label: '警告', body_visibility: true },
    start_reboot: { value: 50, label: '再起動を開始', body_visibility: false },
  }.with_indifferent_access

  enum event_type: EVENT_TYPE.reduce({}) { |a, (event_type, hash)| a[event_type] = hash[:value]; a }

  belongs_to :pbm_session

  def loading_config?
    reload_config? || load_config?
  end

  # @return [Array<String, String, String>] label, body, css_class
  def formatted_event_type_and_body_and_css_class
    return if (event_type_hash = EVENT_TYPE[event_type]).nil?
    return if (label = event_type_hash[:label]).nil?
    event_body = if event_type_hash[:body_visibility]
                   body.to_s
                 else
                   nil
                 end
    return [label, event_body, nil]
  end
end
