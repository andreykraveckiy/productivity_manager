class ProjectsController < ApplicationController
  before_action :check_owner, only: [:update, :destroy]

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
    # @project = Project.find(params[:id])
    # if current_user == @project.user - for correct user i can check it with this condition
    # or use before_action function
    if @project.update_attributes(project_params)
      flash[:success] = "Project was updated" 
      redirect_to root_url    
    else
      flash[:error] = "Project wasn't updated"
      render "edit"
    end
    # end
    # flash[:error] = "You tried change another project"
    # redirect_to root_url 
  end

  def destroy
    # @project = Project.find(params[:id])    
    @project.destroy # if current_user == @project.user this or use before action
    redirect_to root_url
  end

  private

    def project_params
      params.require(:project).permit(:name)
    end

    def check_owner
      @project = current_user.projects.find_by(id: params[:id])
      redirect_to root_url if @project.nil?
    end
end
