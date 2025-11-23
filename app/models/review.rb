class Review < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :rating, presence: true
  validates :comment, presence: true, length: { maximum: 100 }
  validates :user_id, uniqueness: { scope: :event_id }
end
