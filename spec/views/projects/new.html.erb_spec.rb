require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  include Capybara::DSL  

  subject { page } 

  describe "unauthincated user" do
    before { visit new_project_path }
    it { should have_content("Log in") }
  end

  describe "authenticated user" do
    before do 
      @user = FactoryGirl.create(:user, name: "Akuna Matata", email: "akuna@example.com")   
      login_as(@user, :scope => :user)
      visit new_project_path
    end   

    it { should have_title('Create project') }
    it { should have_selector("input") }
    it { should have_selector(:link_or_button) }

    describe "save when input are empty" do
      it "should not change Project count" do
        expect do
          click_button "Do this"
        end.to_not change(Project, :count)
      end
    end

    describe "save some project" do    
      before { fill_in with: "New project" }

      it "should change Project count" do
        expect do
          click_button "Do this"
        end.to change(Project, :count).by(1)
      end

      describe "should get a projects page with new project" do
        before { click_button "Do this" }

        it { should have_content("New project") }
      end
    end

    describe "cancel page" do
      before { click_link "Cancel" }

      it { should have_content("Simple todo lists") }
    end
  end
end
