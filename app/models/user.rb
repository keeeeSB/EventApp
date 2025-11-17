class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :events, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :entry_events, through: :entries, source: :event

  validates :name, presence: true
  validates :introduction, presence: true, length: { maximum: 100 }
end
