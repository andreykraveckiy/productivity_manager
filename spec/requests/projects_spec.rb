require 'rails_helper'

NEW_PROJECT_NAME = "New name"

RSpec.describe "Projects", type: :request do
  include Capybara::DSL   

  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  before do
    @user = FactoryGirl.create(:user, name: "First", email: "first@example.com")
    @project = FactoryGirl.create(:project, name: "First pr", user: @user)   
  end

  describe "unauthincated user" do

    describe "DELETE / project" do
      it "try to delete project" do
        delete project_path(@project)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "UPDATE / project" do
      it "try to update project" do
        patch project_path(@project)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
#expect(response).to have_http_status(200)

  describe "authincated user" do
    before { login_as(@user, :scope => :user) }

    describe "work with own projects" do

      describe "DELETE / project" do
        it "should be deleted" do
          delete project_path(@project)
          expect(response).to have_http_status(302)
        end
      end

      describe "UPDATE / project" do
        before { @project = FactoryGirl.create(:project, name: "First pr", user: @user) }
        it "should be updated" do
          patch project_path(@project, params: { project: { name: NEW_PROJECT_NAME } })
          expect(response).to have_http_status(302)
          expect(@project.reload.name).to eq NEW_PROJECT_NAME
        end
      end
    end

    describe "work with alien projects" do
      before do
        @another_user = FactoryGirl.create(:user, name: "Another", email: "another@example.com")
        @another_project = FactoryGirl.create(:project, name: "Another pr", user: @another_user)
      end

      describe "DELETE / alien project" do
        it "try to delete project" do
          delete project_path(@another_project)
          expect(response).to redirect_to(root_path)
          expect(@another_user.projects.length).to eq 1
        end
      end

      describe "UPDATE / alien project" do
        it "try to update project" do
          patch project_path(@another_project, params: { project: { name: NEW_PROJECT_NAME } })
          expect(response).to redirect_to(root_path)
          expect(@another_project.reload.name).to_not eq NEW_PROJECT_NAME
        end
      end
    end
  end
end
