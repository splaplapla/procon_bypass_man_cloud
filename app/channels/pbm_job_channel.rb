class PbmJobChannel < ActionCable::Channel::Base
  def subscribed
    Rails.logger.info "subscribed with #{params} in pbm_job"
    device = Device.find_by!(uuid: params["device_id"])
    stream_from device.push_token
  end

  def pong
    Rails.logger.info "ping with #{params} in pbm_job"
    device = Device.find_by!(uuid: params["device_id"])

    Rails.cache.fetch([device.cache_key, :pong], expires_in: 50.seconds) do
      device.update_columns(last_access_at: Time.zone.now)
      nil
    end
    ActionCable.server.broadcast(device.web_push_token, { type: 'device_is_active' })
  end
end
