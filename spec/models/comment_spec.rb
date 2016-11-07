require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:task) { FactoryGirl.create(:task) }
  before do
    @comment = task.comments.build(content: "New comment")
  end

  subject { @comment }

  it { should respond_to(:content) }
  it { should respond_to(:attachment) }
  it { should respond_to(:task_id) }

  it { should respond_to(:task) }
  it "should have the correct task" do
    expect(@comment.task).to eq task
  end

  it { should be_valid }

  describe "it should have task_id" do
    before { @comment.task_id = nil }
    it { should be_invalid }
  end

  describe "it should have content" do
    before { @comment.content = " " }
    it { should be_invalid }
  end
end
