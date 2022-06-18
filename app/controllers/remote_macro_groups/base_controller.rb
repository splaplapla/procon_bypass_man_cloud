class RemoteMacroGroups::BaseController < ApplicationController
  private

  def remote_macro_group
    @remote_macro_group ||= current_user.remote_macro_groups.find(params[:remote_macro_group_id])
  end
end
