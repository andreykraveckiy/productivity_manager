class ProjectsController < ApplicationController

  def index
    @projects = current_user.projects
    @task = Task.new
  end

  def new    
    @project = Project.new(user: current_user)
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      flash[:success] = "Project created!"
      redirect_to root_url      
    else
      flash[:error] = "Project not created!"
      render "new"
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(project_params)
      flash[:success] = "Project was updated"       
    else
      flash[:error] = "Project wasn't updated"
    end
    redirect_to root_url
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to root_url
  end

  private

    def project_params
      params.require(:project).permit(:name)
    end
end
