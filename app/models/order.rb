class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :status, presence: true

  enum :status, { pending: "pending", paid: "paid", shipped: "shipped", delivered: "delivered", cancelled: "cancelled" }

  def calculate_total
    update(total: order_items.sum { |item| item.price * item.quantity })
  end
end
