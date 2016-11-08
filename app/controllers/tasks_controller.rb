class TasksController < ApplicationController

  def show
    @task = Task.find(params[:id])
    @comment = Comment.new
  end

  def new
    @task = Task.new
  end

  def create
    project = Project.find(params[:project_id])
    project.tasks.create!(task_params)
    flash[:success] = "Task is added successfully"
    redirect_to root_url
  end

  def edit
    @task = Task.find(params[:id])
    @project = Project.find(params[:project_id])
    @comment = Comment.new  
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      flash[:success] = "Task was updated"       
    else
      flash[:error] = "Task wasn't updated"
    end
    redirect_to root_url
  end

  def destroy
    session[:return_to] ||= request.referer
    @task = Task.find(params[:id])
    @task.destroy
    #redirect_to root_url
    redirect_to session.delete(:return_to)
  end

  def done
    session[:return_to] ||= request.referer
    @task = Task.find(params[:id])
    @task.done!
    flash[:success] = "Task '#{@task.content}' is updated"
    #edirect_to root_url
    redirect_to session.delete(:return_to)
  end

  def up_priority
    session[:return_to] ||= request.referer
    @task = Task.find(params[:id])
    @task.up_priority!
    redirect_to session.delete(:return_to)
  end

  def down_priority
    session[:return_to] ||= request.referer
    @task = Task.find(params[:id])
    @task.down_priority!
    redirect_to session.delete(:return_to)
  end

  private

    def task_params
      params.require(:task).permit(:content, :deadline)
    end
end
