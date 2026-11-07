class ApplicationController < ActionController::Base
  include Pagy::Method

  helper_method :current_cart

  def current_cart
    @current_cart ||= Cart.find_by(id: session[:cart_id]) || Cart.create.tap { |cart| session[:cart_id] = cart.id }
  end
end
