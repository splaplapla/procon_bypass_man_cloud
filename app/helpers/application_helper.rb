module ApplicationHelper
  def wrap_device_status_with_style(status: )
    case status
    when "offline"
      content_tag(:span, status, class: "badge bg-secondary", data: { bs_toggle: "tooltip", bs_placement: "top" }, title: "ネットワークに繋がっていません")
    when "running"
      content_tag(:span, status, class: "badge bg-success")
    when "connected_but_sleeping"
      content_tag(:span, "接続失敗", class: "badge bg-danger", data: { bs_toggle: "tooltip", bs_placement: "top" }, title: "デバイスを再起動して接続の再試行をしてください")
    when "device_error", "connected_but_error", "setting_syntax_error_and_shutdown"
      content_tag(:span, status, class: "badge bg-danger")
    else
      content_tag(:span, status, class: "badge bg-warning")
    end
  end
end
