class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def create
    @order = current_user.orders.find(params[:order_id])

    if @order.paid?
      redirect_to @order, notice: "Order already paid."
      return
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      line_items: @order.order_items.map { |item|
        {
          price_data: {
            currency: "usd",
            product_data: { name: item.product.name },
            unit_amount: (item.price * 100).to_i
          },
          quantity: item.quantity
        }
      },
      mode: "payment",
      success_url: checkout_success_url(order_id: @order.id),
      cancel_url: checkout_cancel_url(order_id: @order.id),
      metadata: { order_id: @order.id }
    )

    @order.create_checkout_session!(
      stripe_session_id: session.id,
      status: "pending"
    )

    redirect_to session.url, allow_other_host: true, status: :see_other
  end

  def success
    @order = current_user.orders.find(params[:order_id])
    redirect_to @order, notice: "Payment successful! Your order is being processed."
  end

  def cancel
    @order = current_user.orders.find(params[:order_id])
    redirect_to @order, notice: "Payment was cancelled. You can try again."
  end
end
