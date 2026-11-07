class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :checkout_sessions, dependent: :destroy

  validates :status, presence: true

  enum :status, { pending: "pending", paid: "paid", shipped: "shipped", delivered: "delivered", cancelled: "cancelled" }

  # Cancels a pending order that nobody can still pay for and gives its stock back, unless a
  # checkout session is still open. The conditional update lets only one caller do the restore.
  def cancel_if_abandoned
    return if checkout_sessions.where(status: %w[pending paid]).exists?

    transaction do
      next unless Order.where(id: id, status: "pending").update_all(status: "cancelled").positive?

      order_items.each do |item|
        Product.where(id: item.product_id).update_all([ "stock = stock + ?", item.quantity ])
      end
    end
  end
end
