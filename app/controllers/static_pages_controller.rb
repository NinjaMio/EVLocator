class StaticPagesController < ApplicationController
  def index
    @projects = Project.all
  end
end
