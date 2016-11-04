class Task < ApplicationRecord
  before_save :set_priority  
  belongs_to :project

  validates :project_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :deadline_cannot_be_in_the_past
  default_scope -> { order('priority ASC') }

  private

    def deadline_cannot_be_in_the_past
      if deadline.present? && deadline <= DateTime.current
        errors.add(:deadline, "can't be in the past and now")
      end
    end

    def set_priority
      self.priority = self.project.tasks.length if self.priority.nil?
    end
end
