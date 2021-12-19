class Admin::SavedButtonsSettings::ContentsController < Admin::Base
  def edit
    @setting = SavedButtonsSetting.find(params[:id])
    @device = @setting.device
    if(setting_content = @setting.content["setting"])
      @config = ProconBypassMan::ButtonsSettingConfiguration.instance.instance_eval(YAML.load(setting_content))
    else
      @config = ProconBypassMan::ButtonsSettingConfiguration.instance
    end
  end

  def update
  end
end
