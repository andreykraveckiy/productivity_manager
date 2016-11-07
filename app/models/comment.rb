class Comment < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader

  validates :content, presence: true
  validates :task_id, presence: true
  belongs_to :task

  default_scope -> { order('created_at DESC') }
end
