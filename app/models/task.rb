class Task < ApplicationRecord
  before_save :set_priority
  belongs_to :project

  private

    def set_priority
      self.priority = self.project.tasks.length if self.priority.nil?
    end
end
