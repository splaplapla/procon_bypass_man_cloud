class RemoteMacroGroupsController < ApplicationController
  def index
    @remote_macro_groups = RemoteMacroGroup.all
  end

  def new
  end

  def create
  end
end
