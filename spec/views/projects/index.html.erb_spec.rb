require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  include Capybara::DSL   

  subject { page }

  describe "unauthincated user" do
    before { visit root_path }
    it { should have_content("Log in") }
  end

  describe "authicanted user" do
    before do 
      @user = FactoryGirl.create(:user, name: "Akuna Matata", email: "akuna@example.com")   
      login_as(@user, :scope => :user)
      visit root_path
    end   

    it { should have_title("Projects") }
    it { should have_selector("h1","SIMPLE TODO LISTS") }
    it { should have_content(@user.name) }
    it { should have_link("Add TODO List",class: "fa-plus") }

    describe "it should have list of projects" do
      before do
        FactoryGirl.create(:project, name: "First", user: @user)
        FactoryGirl.create(:project, name: "Second", user: @user)
        visit root_path
      end

      it "should list each project with links 'edit' and 'delete'" do
        @user.projects.each do |project|
          expect(page).to have_selector('div', text: project.name)
          expect(page).to have_link(class: "fa-pencil", href: edit_project_path(project))
          expect(page).to have_link(class: "fa-trash-o", href: project_path(project))
          expect(page).to have_button(value: "Add Task")
        end
      end

      it "should delete one of projects" do
        expect do
          first(".fa-trash-o").click
        end.to change(Project, :count).by(-1)
      end

      describe "should get a edit page" do
        before { first(".fa-pencil").click }
        it { expect(page).to have_title('Edit project') }
      end

      describe "should add task" do
        it "should change nothing without information" do
          expect do
            first(:button, "Add Task").click
          end.to_not change(Task, :count)
        end

        describe "with information" do
          before do
            within("##{@user.projects.first.id}tf") do
              fill_in with: "abracadabra" 
            end
          end

          it "should change active tasks count" do
            expect do
              first(:button, "Add Task").click
            end.to change(@user.projects.first.tasks.active, :count).by(1)
          end

          describe "should show this task" do
            before { first(:button, "Add Task").click }
            it { should have_content("abracadabra") }
          end
        end
      end

      describe "should show projects' tasks" do
        before do
          3.times do 
            FactoryGirl.create(:task, project: @user.projects.first)
            FactoryGirl.create(:task, project: @user.projects.last)
          end
          visit root_path
        end
        after(:all) { Task.delete_all }

        it "should have links for each task" do
          @user.projects.each do |project|
            project.tasks.each do |task|
              expect(page).to have_content(task.content)
              expect(page).to have_link(class: "fa-pencil", href: edit_project_task_path(project, task))
              expect(page).to have_link(class: "fa-trash-o", href: project_task_path(project,task))
              expect(page).to have_link(class: "fa-sort-up", href: up_priority_project_task_path(project,task))
              expect(page).to have_link(class: "fa-sort-down", href: down_priority_project_task_path(project,task))
              expect(page).to have_link(class: "fa-square-o", href: done_project_task_path(project,task))
            end
          end
        end
        # done task
        it "should change active tasks for first project" do
          expect do
            first(".fa-square-o").click
          end.to change(@user.projects.first.tasks.completed, :count).by(1)
        end

        describe "should hide one of tasks" do
          before { first(".fa-square-o").click }
          specify { expect(page).to have_no_link(@user.projects.first.tasks.completed.last.content) }
        end
        # edit task 
        describe "it should get edit page for task" do
          before do
            within("##{@user.projects.first.id}t//.tasks") do
              first(".fa-pencil").click 
            end
          end

          it { should have_title('Edit task') }
        end
        # delete
        it "should delete 1st task of 1st project" do
          expect do
            within("##{@user.projects.first.id}t//.tasks") do
              first(".fa-trash-o").click 
            end
          end.to change(@user.projects.first.tasks, :count).by(-1)
        end

        describe "down link" do
          before do
            @task_ar = @user.projects.first.tasks.active.to_a
            within("##{@user.projects.first.id}t//.tasks") do
              first(".fa-sort-down").click 
            end
          end

          it { expect(@user.projects.first.tasks.active.first).to eq @task_ar.second }
          it { expect(@user.projects.first.tasks.active.second).to eq @task_ar.first }
        end
        
        describe "up link" do
          before do
            @task_ar = @user.projects.first.tasks.active.to_a
            within("##{@user.projects.first.id}t//.tasks") do
              all(".fa-sort-up").last.click 
            end
          end

          it { expect(@user.projects.first.tasks.active.last).to eq @task_ar[-2] }
          it { expect(@user.projects.first.tasks.active[-2]).to eq @task_ar.last }
        end
      end
    end

    describe "click button 'Add TODO List'" do
      before { find('.fa-plus', text: 'Add TODO List').click }
      it "should get Create project page" do
        expect(page).to have_title('Create project')
      end
    end
  end #authinticate user
end
