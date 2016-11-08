class CommentsController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:task_id])
    @comment = @task.comments.build
  end

  def create    
    session[:return_to] ||= request.referer
    @task = Task.find(params[:task_id])
    @comment = @task.comments.build(comment_params)
    if @comment.save
      flash[:success] = "Comment is added successfully"
    else
      flash[:error] = "Comment is not added: "
      @comment.errors.full_messages.each do |msg|
        flash[:error] << msg
      end
    end
    redirect_to session.delete(:return_to)
  end

  def destroy
    session[:return_to] ||= request.referer
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to session.delete(:return_to)
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :attachment)
    end
end
