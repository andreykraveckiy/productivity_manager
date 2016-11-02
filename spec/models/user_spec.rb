require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  subject { user }

  it { should respond_to(:provider) }
  it { should respond_to(:uid) }
  it { should respond_to(:name) }
end
