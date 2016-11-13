require 'rails_helper'
require 'database_cleaner'

COMMENT_CONTENT = "New comment"
FILE_PATH = 'spec/support/KravetskyiCV.pdf'

RSpec.describe "tasks/show.html.erb", type: :view do
  include Capybara::DSL   
  
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  subject { page }

  before do
    @user = FactoryGirl.create(:user, name: "Akuna Matata", email: "maakuna@example.com")
    project = FactoryGirl.create(:project, name: "First", user: @user)
    @task = FactoryGirl.create(:task, project: project)
  end

  describe "unauthincated user" do
    before { visit project_task_path(@task.project, @task) }
    it { should have_content("Log in") }
  end

  describe "authenticate user" do
    before do
      login_as(@user, :scope => :user)
      visit project_task_path(@task.project, @task)
    end

    it { should have_title('Show task') }
    it { should have_content(@task.content) }
    it { should have_content('Deadline:') }
    it { should have_content('Is done:') }
    it { should have_selector('.fa-square-o') }
    it { should have_link(class: "fa-pencil", href: edit_project_task_path(@task.project, @task)) }
    it { should have_link(class: "fa-trash-o", href: project_task_path(@task.project, @task)) }
  
    describe "back to projects page" do
        before { click_link "Back to projects" }

        it { should have_title("Projects") }
    end

    describe "comments" do
      it { should have_content('Write your comment') }
      it { should have_selector("textarea", id: "comment_content") }
      it { should have_selector("input", id: "comment_attachment") }
      it { should have_button("Save comment") }
      it { should have_content('You haven\'t done any comment for this task.') }

      describe "comments" do
        describe "page allows create comment" do
          describe "create comment without text" do
            before do
              click_button "Save comment" 
            end

            it { should have_title('Show task') }
            it { should have_content("Comment is not added") }
          end

          describe "create a comment without attachment" do
            before do
              fill_in with: COMMENT_CONTENT
              click_button "Save comment"
            end

            it { should have_content(COMMENT_CONTENT) }
            it { should have_link(class: "fa-trash-o", href: project_task_comment_path(@task.project, @task, @task.comments.first)) }

            describe "should delete comment" do
              before do
                within("#comments") do
                  first(".fa-trash-o").click 
                end
              end

              it { should have_no_content(COMMENT_CONTENT) }
            end
          end

          describe "create a comment with attachment" do
            before do
              fill_in with: COMMENT_CONTENT
              attach_file "comment_attachment", FILE_PATH
              click_button "Save comment"
            end

            it { should have_content(COMMENT_CONTENT) }
            it { should have_link(FILE_PATH.split('/').last) }
            it { should have_link(class: "fa-trash-o", href: project_task_comment_path(@task.project, @task, @task.comments.first)) }

            describe "should delete comment" do
              before do
                within("#comments") do
                  first(".fa-trash-o").click 
                end
              end

              it { should have_no_content(COMMENT_CONTENT) }
              it { should have_no_link(FILE_PATH.split('/').last) }
            end
          end
        end
      end
    end
  end
end