class ProjectsController < ApplicationController
  def index
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.create(project_params)
    redirect_to root_path
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
