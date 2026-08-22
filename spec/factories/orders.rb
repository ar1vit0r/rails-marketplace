FactoryBot.define do
  factory :order do
    status { "pending" }
    total { 0 }
    user
  end
end
