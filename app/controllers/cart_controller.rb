class CartController < ApplicationController
  def show
    @cart_items = current_cart.cart_items.includes(product: :user)
  end

  def add
    product = Product.find(params[:product_id])
    cart_item = current_cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity = cart_item.quantity.to_i + 1

    if cart_item.quantity > product.stock
      redirect_to cart_path, alert: "Not enough stock for #{product.name}."
    elsif cart_item.save
      redirect_to cart_path, notice: "#{product.name} added to cart!"
    else
      redirect_to cart_path, alert: "Could not add #{product.name} to the cart."
    end
  end

  def remove
    cart_item = current_cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end
end
