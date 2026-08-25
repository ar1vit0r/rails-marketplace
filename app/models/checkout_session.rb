class CheckoutSession < ApplicationRecord
  belongs_to :order

  validates :stripe_session_id, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[pending paid expired failed] }

  enum :status, { pending: "pending", paid: "paid", expired: "expired", failed: "failed" }
end
