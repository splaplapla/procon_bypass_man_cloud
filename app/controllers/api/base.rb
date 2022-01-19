class Api::Base < ActionController::Base
  skip_before_action :verify_authenticity_token

  around_action :switch_locale

  # TODO RecordNotFoundとか起きたらjsonを返す

  def get_device
    @device ||= Device.find_or_create_by!(uuid: params[:device_id])
  end

  def switch_locale(&action)
    locale = :en

    I18n.with_locale(locale, &action)
  end
end
