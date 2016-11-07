class Task < ApplicationRecord
  before_save :set_priority  
  belongs_to :project

  validates :project_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :deadline_cannot_be_in_the_past
  default_scope -> { order('priority ASC') }
  scope :active, -> { where(done: false) }
  scope :completed, -> { where(done: true) }

  def done!
    self.done = true
    save
    tasks = self.project.tasks.where("priority > ? and done = ?", self.priority, false)
    if tasks.any?
      tasks.each do |task|
        task.priority = task.priority - 1
        task.save!
      end
    end
  end

  def up_priority!
    if self.priority > 0
      task = self.project.tasks.where("priority = ? and done = ?", self.priority - 1, false)
      task[0].priority = task[0].priority + 1
      self.priority = self.priority - 1
      task[0].save!
      self.save!
    end
  end

  def down_priority!
    if self.priority < (self.project.tasks.active.length - 1)
      task = self.project.tasks.where("priority = ? and done = ?", self.priority + 1, false)
      task[0].priority = task[0].priority - 1
      self.priority = self.priority + 1
      task[0].save!
      self.save!
    end
  end

  private

    def deadline_cannot_be_in_the_past
      if deadline.present? && deadline <= DateTime.now
        errors.add(:deadline, "can't be in the past and now")
      end
    end

    def set_priority
      # pririty of tasks, which are done, not important for plans. They are done!
      self.priority = self.project.tasks.active.length if self.priority.nil?
    end
end
