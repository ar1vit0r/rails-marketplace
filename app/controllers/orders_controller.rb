class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    items = current_cart.cart_items.includes(:product).to_a

    if items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
    elsif items.any? { |item| item.quantity > item.product.stock }
      redirect_to cart_path, alert: "Some items are no longer available in that quantity."
    else
      redirect_to place_order(items), notice: "Order placed successfully!"
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to cart_path, alert: "Could not place order."
  end

  def show
    @order = current_user.orders.includes(order_items: :product).find(params[:id])
  end

  private

  def place_order(items)
    Order.transaction do
      order = current_user.orders.create!(status: "pending", total: items.sum { |item| item.product.price * item.quantity })
      items.each do |item|
        order.order_items.create!(product: item.product, quantity: item.quantity, price: item.product.price)
      end
      current_cart.cart_items.destroy_all
      order
    end
  end
end
