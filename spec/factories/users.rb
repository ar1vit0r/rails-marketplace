FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password123" }
    role { "user" }

    trait :admin do
      role { "admin" }
    end

    trait :seller do
      role { "seller" }
    end
  end
end
