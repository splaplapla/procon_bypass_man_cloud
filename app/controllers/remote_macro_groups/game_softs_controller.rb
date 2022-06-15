class RemoteMacroGroups::GameSoftsController < RemoteMacroGroups::BaseController
  def index
    @remote_macro_group = remote_macro_group
    @game_softs = GameSoft.all
  end
end
