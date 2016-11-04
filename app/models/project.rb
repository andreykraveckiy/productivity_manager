class Project < ApplicationRecord
  validates :name, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  belongs_to :user
  default_scope -> { order('created_at ASC') }

  has_many :tasks, dependent: :destroy
end
