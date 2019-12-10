class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def show
    @project = Project.find_by_id(params[:id])
    return render_not_found if @project.blank?
  end

  def create
    @project = current_user.projects.create(project_params)
    if @project.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @project = Project.find_by_id(params[:id])
    return render_not_found if @project.blank?
    return render_not_found(:forbidden) if @project.user != current_user
  end

  def update
    @project = Project.find_by_id(params[:id])
    return render_not_found if @project.blank?
    return render_not_found(:forbidden) if @project.user != current_user

    @project.update_attributes(project_params)

    if @project.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project = Project.find_by_id(params[:id])
    return render_not_found if @project.blank?
    return render_not_found(:forbidden) if @project.user != current_user

    @project.destroy
    redirect_to root_path
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :picture)
  end
end
