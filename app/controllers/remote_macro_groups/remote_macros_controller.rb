class RemoteMacroGroups::RemoteMacrosController < RemoteMacroGroups::BaseController
  def create
    remote_macro_group = self.remote_macro_group
    game_soft = GameSoft.all.find(params[:game_soft_id])
    remote_macro_template = game_soft.remote_macro_templates.find(params[:remote_macro_template_id])
    remote_macro_group.remote_macros.create!(name: remote_macro_template.title, steps: remote_macro_template.steps)
    redirect_to remote_macro_group_path(remote_macro_group), notice: "テンプレートからの取り込みに成功しました"
  end
end
