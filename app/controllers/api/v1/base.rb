class Api::V1::Base < ActionController::Base
  skip_forgery_protection

  around_action :switch_locale

  def switch_locale(&action)
    locale = :en

    I18n.with_locale(locale, &action)
  end
end
