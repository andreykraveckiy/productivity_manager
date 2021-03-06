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

  describe "priority and done" do
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

    describe "should change done" do
      before { @task.done! }

      it { expect(@task.done).to eq true }
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

  describe "comments' assotiations" do
    before { @task.save }
    let!(:comment0) { FactoryGirl.create(:comment, content: "boo", task: @task, created_at: 1.day.ago) }
    let!(:comment1) { FactoryGirl.create(:comment, content: "baa", task: @task, created_at: 1.hour.ago) }

    it "should have newer comments first" do
      expect(@task.comments.to_a).to eq [comment1, comment0]
    end

    it "should destroy associated comments" do
      comments = @task.comments.to_a
      @task.destroy
      expect(comments).not_to be_empty
      comments.each do |comment|
        expect(Comment.where(id: comment.id)).to be_empty
      end
    end
  end
end
