require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:project) { FactoryGirl.create(:project) }
  before do
    @task = project.tasks.build(content: "New task")
  end

  subject { @task }

  it { should respond_to(:content) }
  it { should respond_to(:deadline) }
  it { should respond_to(:done) }
  it { should respond_to(:priority) }
  it { should respond_to(:project_id) }
  # assotiations
  it { should respond_to(:project) }
  it "should have the correct user" do
    expect(@task.project).to eq project
  end

  it { should be_valid }

  describe "set priority" do
    before { @task.save }

    it "should have priority not nil" do
      expect(@task.priority).to eq project.tasks.length
    end
  end
end
