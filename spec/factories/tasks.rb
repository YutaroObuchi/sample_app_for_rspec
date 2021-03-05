FactoryBot.define do
  factory :task do
    title { "資料作り" }
    content { "資料作り" }
    status { 0 }
    deadline { "明後日" }
    association :user
  end
end
