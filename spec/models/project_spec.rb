require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @project = user.projects.build(name: "Project1")
  end

  subject { @project }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  #assotiations
  it { should respond_to(:user) }
  it "should have the correct user" do
    expect(@project.user).to eq user
  end

  it { should be_valid }

  describe "when name is absend" do
    before { @project.name = "" }
    it { should_not be_valid }
  end

  describe "when owner(user) is absend" do
    before { @project.user_id = nil }
    it { should_not be_valid }
  end

  describe "name to long" do
    before { @project.name = "a" * 141 }
    it { should be_invalid }
  end

  describe "tasks' assotiations" do
    before { @project.save }
    let!(:task0) { FactoryGirl.create(:task, content: "boo", project: @project, priority: 0) }
    let!(:task1) { FactoryGirl.create(:task, content: "boo", project: @project, priority: 1) }

    it "should have task with smaller priority first" do
      expect(@project.tasks.to_a).to eq [task0, task1]
    end

    it "should destroy associated tasks" do
      tasks = @project.tasks.to_a
      @project.destroy
      expect(tasks).not_to be_empty
      tasks.each do |task|
        expect(Task.where(id: task.id)).to be_empty
      end
    end
  end
end
