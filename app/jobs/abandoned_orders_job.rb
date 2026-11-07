# Gives back the stock of orders that were placed but never reached Stripe checkout. Orders with
# a checkout session are handled by the checkout.session.expired webhook instead.
class AbandonedOrdersJob < ApplicationJob
  GRACE_PERIOD = 2.hours

  def perform
    Order.pending.where(created_at: ...GRACE_PERIOD.ago).find_each(&:cancel_if_abandoned)
  end
end
