class CartController < ApplicationController
  def show
    @cart_items = current_cart.cart_items.includes(product: :user)
  end

  def add
    product = Product.find(params[:product_id])
    cart_item = current_cart.cart_items.find_by(product: product)

    if cart_item
      cart_item.update(quantity: cart_item.quantity + 1)
    else
      current_cart.cart_items.create(product: product, quantity: 1)
    end

    redirect_to cart_path, notice: "#{product.name} added to cart!"
  end

  def remove
    cart_item = current_cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end
end
