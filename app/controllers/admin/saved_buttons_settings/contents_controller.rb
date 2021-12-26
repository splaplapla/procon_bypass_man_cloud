class Admin::SavedButtonsSettings::ContentsController < Admin::Base
  def edit
    @setting = SavedButtonsSetting.find(params[:id])
    @device = @setting.device
    if(setting_content = @setting.content["setting"])
      # TODO 悪意のある設定情報がクライアントから送られてきたらRCEになってしまう. どうしよ
      @config = ProconBypassMan::ButtonsSettingConfiguration.instance.instance_eval(
        YAML.safe_load(setting_content)
      )
    else
      @config = ProconBypassMan::ButtonsSettingConfiguration.instance
    end
  end

  def update
  end
end
