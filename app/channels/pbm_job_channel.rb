class PbmJobChannel < ActionCable::Channel::Base
  def subscribed
    Rails.logger.info "subscribed with #{params} in pbm_job"
    device = Device.find_by!(uuid: params["device_id"])
    stream_from device.push_token
  end
end
