class TasksController < ApplicationController

  def show
    @task = Task.find(params[:id])
    @comment = Comment.new
  end

  def new
    @task = Task.new
  end

  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.build(task_params)
    if @task.save
      flash[:success] = "Task is added successfully"
    else
      flash[:error] = "Task not created: "
      @task.errors.full_messages.each do |msg|
        flash[:error] << msg
      end
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def edit
    @task = Task.find(params[:id])
    @project = Project.find(params[:project_id])
    @comment = Comment.new  
  end

  def update
    @task = Task.find(params[:id])
    @project = Project.find(params[:project_id])
    @comment = Comment.new
    if @task.update_attributes(task_params)
      flash[:success] = "Task was updated" 
      redirect_to root_url      
    else
      flash[:error] = "Task wasn't updated: "
      @task.errors.full_messages.each do |msg|
        flash[:error] << msg
      end
      render "edit"
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @task = Task.find(params[:id])
    @task.destroy
    #redirect_to root_url
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to) }
      format.js
    end
  end

  def done
    session[:return_to] ||= request.referer
    @task = Task.find(params[:id])
    @task.done!
    flash[:success] = "Task '#{@task.content}' is updated"
    #edirect_to root_url
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to) }
      format.js
    end
  end

  def up_priority
    session[:return_to] ||= request.referer
    @task = Task.find(params[:id])
    @task.up_priority!
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to) }
      format.js
    end
  end

  def down_priority
    session[:return_to] ||= request.referer
    @task = Task.find(params[:id])
    @task.down_priority!
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to) }
      format.js
    end
  end

  private

    def task_params
      params.require(:task).permit(:content, :deadline)
    end
end
