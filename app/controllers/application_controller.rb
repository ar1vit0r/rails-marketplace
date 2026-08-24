class ApplicationController < ActionController::Base
  include Pagy::Method

  helper_method :current_cart

  def current_cart
    @current_cart ||= if session[:cart_id]
      Cart.find_by(id: session[:cart_id])
    else
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
  end
end
