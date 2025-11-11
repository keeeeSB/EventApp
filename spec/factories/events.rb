FactoryBot.define do
  factory :event do
    title { 'MyString' }
    description { 'MyText' }
    started_at { '2025-11-11 12:25:28' }
    venue { 'MyString' }
    user { nil }
    category { nil }
  end
end
