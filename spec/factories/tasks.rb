FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "テスト#{n}" }
    content {'これはテストです。'}
    status {0}
    deadline {Time.new}
    association :user
  end
end
