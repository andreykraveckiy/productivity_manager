require 'rails_helper'

RSpec.describe "projects/edit", type: :view do
  include Capybara::DSL   
  let(:user) { FactoryGirl.create(:user, name: "Akuna Matata", email: "akuna@example.com") }
  let(:project) { FactoryGirl.create(:project, name: "First", user: user) }

  subject { page }

  describe "unauthincated user" do
    before { visit edit_project_path(project) }
    it { should have_content("Log in") }
  end

  describe "authenticate user" do
    before do
      login_as(user, :scope => :user)
      visit edit_project_path(project)
    end

    it { should have_title('Edit project') }
    it { should have_selector('textarea', text: project.name) }
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
      
    end
  end
end