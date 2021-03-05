FactoryBot.define do
  factory :task do
    sequence(:title, "title_1") 
    content { "資料作り" }
    status { :todo }
    deadline { "明後日" }
    association :user
  end
end
