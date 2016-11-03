class ProjectsController < ApplicationController

  def index
    @projects = current_user.projects
    @project = current_user.projects.build
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save!
      flash[:success] = "Project created!"      
    else
      flash[:error] = "Project not created!"
    end
    redirect_to root_url
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(project_params)
      flash[:success] = "Project updated"       
      @project = nil     
      redirect_to root_url
    else
      render 'edit'
    end
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
