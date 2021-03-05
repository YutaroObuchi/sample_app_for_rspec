FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "sample_#{n}@example.com" }
    password { "111111" }
    password_confirmation { "111111" }
  end
end
