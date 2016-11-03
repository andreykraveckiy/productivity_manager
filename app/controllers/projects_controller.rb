class ProjectsController < ApplicationController
  def index
  	@projects = Project.all
  end

  def current_user
  	User.new(name: "Example User")
  end
end
