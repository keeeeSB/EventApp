FactoryBot.define do
  factory :entry do
    status { '0' }
    user
    event
  end
end
