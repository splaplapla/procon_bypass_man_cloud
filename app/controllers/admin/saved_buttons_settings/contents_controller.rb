class Admin::SavedButtonsSettings::ContentsController < Admin::Base
  def edit
    @setting = SavedButtonsSetting.find(params[:id])
    @device = @setting.device
  end

  def update
  end
end
