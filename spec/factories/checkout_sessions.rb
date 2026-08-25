FactoryBot.define do
  factory :checkout_session do
    stripe_session_id { "cs_test_#{SecureRandom.hex(12)}" }
    status { "pending" }
    order
  end
end
