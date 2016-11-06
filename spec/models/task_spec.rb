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

  describe "priority and done would be not nil" do
    before do
      t = FactoryGirl.create(:task, project: project, done: true)
      t.save
      @task.save
    end

    it "project should have 2 tasks" do
      expect(@task.project.tasks.length).to eq 2
    end

    it "should have priority not nil" do
      # -1, because after saving project's collection change at 1
      expect(@task.priority).to eq project.tasks.where("done = ?", false).length - 1
    end

    it "should have done equel false" do
      expect(@task.done).to eq false
    end
  end

  describe "project id must be present" do
    before { @task.project_id = nil }
    it { should be_invalid }
  end

  describe "content should be present" do
    before { @task.content = "" }
    it { should be_invalid }
  end

  describe "content to long" do
    before { @task.content = "a" * 141 }
    it { should be_invalid }
  end

  describe "deadline shouldn't be in the past or now" do
    before { @task.deadline = DateTime.current }
    it { should be_invalid }
  end
end
