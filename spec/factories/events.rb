FactoryBot.define do
  factory :event do
    title { 'Ruby勉強会' }
    description { '勉強会を開催します！' }
    started_at { Tine.current + 1.day }
    venue { '各家庭' }
    user
    category

    trait :upcoming do
      started_at { Time.current + 3.days }
    end

    trait :past do
      started_at { Time.current - 3.days }
    end
  end
end
