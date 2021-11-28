class Api::Base < ActionController::Base
  skip_before_action :verify_authenticity_token

  # TODO RecordNotFoundとか起きたらjsonを返す

  def get_device
    @device ||= Device.find_by!(uuid: params[:device_id])
  end
end
