require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  include Capybara::DSL   
  before do 
    @user = FactoryGirl.create(:user, name: "Akuna Matata", email: "akuna@example.com")   
    login_as(@user, :scope => :user)
    visit new_project_path
  end 

  subject { page }

  it { should have_title('Create project') }
  it { should have_selector("input") }
  it { should have_selector(:link_or_button) }

  describe "save when input are empty" do
    it "should not change Project count" do
      expect do
        click_button
      end.to_not change(Project, :count)
    end
  end

  describe "save some project" do    
    before { fill_in "with: "New project" }

    it "should change Project count" do
      expect do
        click_button
      end.to change(Project, :count).by(1)
    end
  end
end
