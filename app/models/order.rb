class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :checkout_sessions, dependent: :destroy

  validates :status, presence: true

  enum :status, { pending: "pending", paid: "paid", shipped: "shipped", delivered: "delivered", cancelled: "cancelled" }
end
