class Admin::SavedButtonsSettings::ContentsController < Admin::Base
  def edit
    @setting = SavedButtonsSetting.find(params[:id])
    @device = @setting.device
    if(setting_content = @setting.content["setting"])
      # TODO 悪意のある設定情報がクライアントから送られてきたらRCEになってしまう. どうしよ
      @config = ProconBypassMan::ButtonsSettingConfiguration.new.instance_eval(
        setting_content
      )
    else
      @config = ProconBypassMan::ButtonsSettingConfiguration.new
    end
  end

  def update
  end
end
