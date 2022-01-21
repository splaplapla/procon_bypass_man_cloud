# TODO USERスコープできる必要がある
class Admin::SavedButtonsSettingsController < Admin::Base
  def index
    @settings = SavedButtonsSetting.all
  end

  def update
    @setting = SavedButtonsSetting.find(params[:id])
    form = Admin::SavedButtonsSetting::UpdateForm.new(name: params[:name], memo: params[:memo], content: params[:content])
    if form.valid?
      @setting.update!(form.to_h)
      redirect_to admin_saved_buttons_settings_path, notice: "更新に成功しました"
    else
      redirect_to admin_saved_buttons_settings_path, notice: "更新に失敗しました"
    end
  end

  def destroy
    @setting = SavedButtonsSetting.find(params[:id])
    @setting.destroy
    redirect_to admin_saved_buttons_settings_path, notice: "削除に成功しました"
  end
end
