module ApplicationHelper
  def wrap_device_status_with_style(status: )
    case status
    when "offline"
      content_tag(:span, status, class: "badge bg-secondary")
    when "running"
      content_tag(:span, status, class: "badge bg-success")
    when "connected_but_sleeping"
      content_tag(:span, "Switchとの接続に失敗しました。PBMかRaspberry Piを再起動してください。", class: "badge bg-danger")
    when "device_error", "connected_but_error", "setting_syntax_error_and_shutdown"
      content_tag(:span, status, class: "badge bg-danger")
    else
      content_tag(:span, status, class: "badge bg-warning")
    end
  end
end
