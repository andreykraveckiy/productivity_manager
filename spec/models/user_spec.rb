require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  subject { user }

  it { should respond_to(:provider) }
  it { should respond_to(:uid) }
  it { should respond_to(:name) }
  it { should respond_to(:projects) }

  it { should be_valid }

  describe "project assotiations" do
    before { user.save }
    let!(:older_project) { FactoryGirl.create(:project, name: "First", user: user, created_at: 1.day.ago) }
    let!(:newer_project) { FactoryGirl.create(:project, name: "Second", user: user, created_at: 1.hour.ago) }

    it "should show erlier projects first" do
      expect(user.projects.to_a).to eq [older_project, newer_project]
    end
  end
end
