class RemoteMacroGroups::RemoteMacroTemplatesController < RemoteMacroGroups::BaseController
  def index
    @remote_macro_group = remote_macro_group
    @game_soft = GameSoft.all.find(params[:game_soft_id])
    @remote_macro_templates = @game_soft.remote_macro_templates
  end
end
