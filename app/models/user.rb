class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :events, dependent: :destroy

  validates :name, presence: true
  validates :introduction, presence: true, length: { maximum: 100 }
end
