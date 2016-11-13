require 'rails_helper'

RSpec.describe "projects/edit", type: :view do
  include Capybara::DSL   
  
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean 

  before do
    @user = FactoryGirl.create(:user, name: "Akuna Matata", email: "maakuna@example.com")
    @project = FactoryGirl.create(:project, name: "First", user: @user)
    5.times { FactoryGirl.create(:task, project: @project) }
  end

  subject { page }

  describe "unauthincated user" do
    before { visit edit_project_path(@project) }
    it { should have_content("Log in") }
  end

  describe "authenticate user" do
    before do
      login_as(@user, :scope => :user)
      visit edit_project_path(@project)
    end

    it { should have_title('Edit project') }
    it { should have_selector('textarea', text: @project.name) }
    it { should have_button("Do this") }
    it { should have_link("Cancel") }

    describe "save when input are empty" do
      before do
        fill_in with: " "
        click_button "Do this"
      end

      it { should have_title('Edit project') }
      it { should have_selector(".error-explanation")}
    end

    describe "save some project" do    
      before do 
        fill_in with: "Another name"
        click_button "Do this"
      end

      it { should have_content("Another name") }
    end

    describe "cancel page" do
      before { click_link "Cancel" }

      it { should have_content("Simple todo lists") }
    end

    describe "tasks' block" do
      after(:all) { Task.delete_all }

      it "should have each task on the page with correct link" do
        @project.tasks.active.each do |task|
          expect(page).to have_link(task.content, project_task_path(@project, task))
          expect(page).to have_link(class: "fa-pencil", href: edit_project_task_path(@project, task))
          expect(page).to have_link(class: "fa-trash-o", href: project_task_path(@project,task))
          expect(page).to have_link(class: "fa-sort-up", href: up_priority_project_task_path(@project,task))
          expect(page).to have_link(class: "fa-sort-down", href: down_priority_project_task_path(@project,task))
          expect(page).to have_link(class: "fa-square-o", href: done_project_task_path(@project,task))
        end
      end

      describe "done action for task" do
        it "should change active tasks for first project" do
          expect do
            first(".fa-square-o").click
          end.to change(@project.tasks.completed, :count).by(1)
        end

        it { should_not have_selector(".fa-check-square-o")}

        describe "should line-through one of tasks" do
          before { first(".fa-square-o").click }
          specify { expect(page).to have_no_link(@project.tasks.completed.last.content) }
          specify { expect(page).to have_content(@project.tasks.completed.last.content) }
          specify { expect(page).to have_selector(".fa-check-square-o") }
        end
      end
      # edit task 
      describe "it should get edit page for task" do
        before do
          within("##{@project.id}t//.tasks") do
            first(".fa-pencil").click 
          end
        end
  
         it { should have_title('Edit task') }
      end
      # delete
      it "should delete 1st task of 1st project" do
        expect do
          within("##{@project.id}t//.tasks") do
            first(".fa-trash-o").click 
          end
        end.to change(@project.tasks, :count).by(-1)
      end

      describe "down link" do
        before do
          @task_ar = @project.tasks.active.to_a
          within("##{@project.id}t//.tasks") do
            first(".fa-sort-down").click 
          end
        end

        it { expect(@project.tasks.active.first).to eq @task_ar.second }
        it { expect(@project.tasks.active.second).to eq @task_ar.first }
      end
        
      describe "up link" do
        before do
          @task_ar = @project.tasks.active.to_a
          within("##{@project.id}t//.tasks") do
          all(".fa-sort-up").last.click 
          end
        end

        it { expect(@project.tasks.active.last).to eq @task_ar[-2] }
        it { expect(@project.tasks.active[-2]).to eq @task_ar.last }
      end
    end
  end
end