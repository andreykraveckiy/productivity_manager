class Task < ApplicationRecord
  before_save :set_priority  
  belongs_to :project

  validates :project_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :deadline_cannot_be_in_the_past
  default_scope -> { order('priority ASC') }
  scope :active, -> { where(done: false) }
  scope :completed, -> { where(done: true) }

  has_many :comments, dependent: :destroy

  def done!
    update_attribute(:done, true)
    #save
    #tasks = self.project.tasks.where("priority > ? and done = ?", self.priority, false)
    #if tasks.any?
    #  tasks.each do |task|
    #    task.priority = task.priority - 1
    #    task.save!
    #  end
    #end
  end

  def up_priority!
      tasks_ar = self.project.tasks.active.to_a
      index = tasks_ar.index(self) - 1
    if index >= 0
      another_task = tasks_ar[index]
      priority = another_task.priority
      another_task.update_attribute(:priority, self.priority)
      update_attribute(:priority, priority)
    end
  end

  def down_priority!    
      tasks_ar = self.project.tasks.active.to_a
      index = tasks_ar.index(self) + 1
    if index < self.project.tasks.active.length
      another_task = tasks_ar[index]
      priority = another_task.priority
      another_task.update_attribute(:priority, self.priority)
      update_attribute(:priority, priority)
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
      if self.priority.nil?
        tasks_ar = self.project.tasks.active.to_a
        unless tasks_ar.empty?
          self.priority = tasks_ar.last.priority + 1 
        else
          self.priority = 0
        end
      end
    end
end
