FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "テスト#{n}" }
    content { "これはテストです。" }
    status { :todo }
    deadline { 1.week.from_now }
    association :user
  end
end
