class RemoteMacroGroupsController < ApplicationController
  def index
    @remote_macro_groups = RemoteMacroGroup.all
  end

  def create
  end
end
