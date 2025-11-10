FactoryBot.define do
  factory :user do
    name { 'アリス' }
    sequence(:email) { "user_#{_1}@example.com" }
    password { 'password12345' }
    confirmed_at { Time.current }
    introduction { 'よろしくお願いします。' }
  end
end
