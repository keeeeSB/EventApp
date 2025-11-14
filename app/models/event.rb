class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, presence: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :started_at, presence: true
  validates :venue, presence: true

  scope :default_order, -> { order(id: :asc) }
  scope :upcoming, -> { where('started_at >= ?', Time.current) }
  scope :past, -> { where('started_at < ?', Time.current) }
end
