class Api::DeviceStatusesController < Api::Base
  def create
    form = Api::CreateDeviceStatsForm.new(permitted_params)
    form.validate!

    device = get_device
    Device::CreateDeviceStatusService.new(device: device, pbm_session_id: form.pbm_session_id).execute(status: form.status)

    render json: {}, status: :ok
  rescue ActiveModel::ValidationError => e
    render json: { errors: e.model.errors.full_messages }, status: :bad_request
  end

  private

  def permitted_params
    params.fetch(:body, {}).permit(:status, :pbm_session_id)
  end
end
