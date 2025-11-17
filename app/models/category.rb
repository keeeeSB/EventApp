class Category < ApplicationRecord
  has_many :events, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :default_order, -> { order(id: :asc) }
end
