FactoryBot.define do
  factory :product do
    name { "MyString" }
    description { "MyText" }
    price { "9.99" }
    category { nil }
    user { nil }
    stock { 1 }
  end
end
