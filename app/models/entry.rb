class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum :status, { pending: 0, accepted: 1, rejected: 2 }

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :user_id, uniqueness: { scope: :event_id }

  scope :default_order, -> { order(created_at: :asc, id: :asc) }
end
