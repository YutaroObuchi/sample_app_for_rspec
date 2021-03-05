FactoryBot.define do
  factory :user do
    email { "sample@sample.com" }
    password { "111111" }
    password_confirmation { "111111" }
  end
end
