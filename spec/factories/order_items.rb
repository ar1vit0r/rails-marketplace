FactoryBot.define do
  factory :order_item do
    quantity { 1 }
    price { 10.00 }
    order
    product
  end
end
