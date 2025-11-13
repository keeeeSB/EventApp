FactoryBot.define do
  factory :category do
    sequence(:name) { "カテゴリー#{_1}"}
  end
end
