class Devices::Actions::ProconStatusesController < ApplicationController
  def create
    device = current_user.devices.find_by!(unique_key: params[:device_id])
    pbm_job = Admin::PbmJob::CreateReportProconStatusService.new(device: device).execute!
    ActionCable.server.broadcast(device.push_token, pbm_job.serialize)
  end
end
