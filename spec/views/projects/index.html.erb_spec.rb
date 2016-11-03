require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  include Capybara::DSL 
  let(:user) { FactoryGirl.create(:user, name: "Akuna Matata") }
  before do    
    login_as(user, :scope => :user)
  end 
  subject { page }
  before { visit root_path }

  it { should have_title("Projects") }
  it { should have_selector("h1","SIMPLE TODO LISTS") }
  it { should have_content("Akuna Matata") }
end
