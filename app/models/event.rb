class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, presence: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :started_at, presence: true
  validates :venue, presence: true

  scope :default_order, -> { order(id: :asc) }
end
