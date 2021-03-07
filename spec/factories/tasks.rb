FactoryBot.define do
  factory :task do
    sequence(:title, "title_1") 
    content { "資料作り" }
    status { :todo }
    deadline { "2021/3/6 22:39" }
    association :user
  end
end
