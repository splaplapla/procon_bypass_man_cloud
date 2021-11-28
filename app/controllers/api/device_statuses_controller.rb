class Api::DeviceStatusesController < Api::Base
  def create
    form = Api::CreateDeviceStatsForm.new(permitted_params)
    form.validate!

    device = get_device
    device.device_statuses.create!(stats: form.stats)
    render json: {}, status: :ok
  rescue ActiveModel::ValidationError => e
    render json: { errors: e.model.errors.full_messages }, status: :bad_request
  end

  private

  def permitted_params
    params.permit(:stats)
  end
end
