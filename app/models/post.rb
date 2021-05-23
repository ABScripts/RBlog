class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'

  validates :title, presence: true

  scope:ordered, -> (direction = :desc) { order(created_at: direction) }
  scope:with_authors, -> { includes(:author) }
end
