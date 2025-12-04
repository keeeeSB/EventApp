class Review < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :rating, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 5 }
  validates :comment, presence: true, length: { maximum: 100 }
  validates :user_id, uniqueness: { scope: :event_id }

  scope :default_order, -> { order(id: :asc) }
end
