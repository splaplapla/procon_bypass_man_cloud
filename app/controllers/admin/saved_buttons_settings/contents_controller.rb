class Admin::SavedButtonsSettings::ContentsController < Admin::Base
  def edit
    @setting = SavedButtonsSetting.find(params[:id])
    @device = @setting.device
    @config = ProconBypassMan::ButtonsSettingConfiguration.instance.instance_eval(YAML.load(@setting.content)["setting"])
  end

  def update
  end
end
