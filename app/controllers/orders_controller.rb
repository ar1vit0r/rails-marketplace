class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    @order = current_user.orders.build(status: "pending", total: current_cart.total)

    if @order.save
      current_cart.cart_items.includes(:product).each do |cart_item|
        @order.order_items.create(
          product: cart_item.product,
          quantity: cart_item.quantity,
          price: cart_item.product.price
        )
      end
      current_cart.cart_items.destroy_all
      redirect_to @order, notice: "Order placed successfully!"
    else
      redirect_to cart_path, alert: "Could not place order."
    end
  end

  def show
    @order = current_user.orders.includes(order_items: :product).find(params[:id])
  end
end
