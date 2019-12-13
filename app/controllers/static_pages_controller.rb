class StaticPagesController < ApplicationController
  def index
    @projects = Project.all
    # gon.places = @project.places.first
  end
end
