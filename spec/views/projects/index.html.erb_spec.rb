require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  include Capybara::DSL   
  before do 
    @user = FactoryGirl.create(:user, name: "Akuna Matata", email: "akuna@example.com")   
    login_as(@user, :scope => :user)
    visit root_path
  end 

  subject { page }

  it { should have_title("Projects") }
  it { should have_selector("h1","SIMPLE TODO LISTS") }
  it { should have_content(@user.name) }
  it { should have_selector(:link_or_button, "Add TODO List") }

  describe "it should have list of projects" do
    before do
      FactoryGirl.create(:project, name: "First", user: @user)
      FactoryGirl.create(:project, name: "Second", user: @user)
      visit root_path
    end

    it "should list each project with links 'edit' and 'delete'" do
      @user.projects.each do |project|
        expect(page).to have_selector('li', text: project.name)
        expect(page).to have_link('edit', edit_project_path(project))
        expect(page).to have_link('delete', project_path(project))
      end
    end

    it "should delete one project" do
      expect do
        first('.project').click_link('delete')
      end.to change(Project, :count).by(-1)
    end

    describe "should get edit page" do
      before { first('.project').click_link('edit') }
      it { should have_title('Edit project') }
    end
  end

  describe "'Add TODO List' should get page for new progect" do
    before  { click_button "Add TODO List" }
    it { should have_title('Create project') }
  end
end
