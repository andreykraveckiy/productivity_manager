class Task < ApplicationRecord
  before_save :set_priority  
  belongs_to :project

  validates :project_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :deadline_cannot_be_in_the_past
  default_scope -> { order('priority ASC') }

  def done!
    self.done = true
    save
    #tasks = self.project.tasks.where("priority > ?", self.priority)
    #if tasks.any?
    #  tasks.each do |task|
    #    task.priotiry = task.priotiry - 1
    #  end
    #  tasks.save
    #end
  end

  private

    def deadline_cannot_be_in_the_past
      if deadline.present? && deadline <= DateTime.current
        errors.add(:deadline, "can't be in the past and now")
      end
    end

    def set_priority
      # pririty of tasks, which are done, not important for plans. They are done!
      self.priority = self.project.tasks.where("done = ?", false).length if self.priority.nil?
    end
end
