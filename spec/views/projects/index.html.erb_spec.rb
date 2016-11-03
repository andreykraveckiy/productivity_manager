require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  include Capybara::DSL  
  subject { page }
  before { visit root_path }

  it { should have_title("Projects") }
  it { should have_selector("h1","SIMPLE TODO LISTS") }
end
