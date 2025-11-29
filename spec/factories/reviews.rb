FactoryBot.define do
  factory :review do
    rating { 5 }
    comment { 'とてもいいイベントでした。' }
    user
    event
  end
end
