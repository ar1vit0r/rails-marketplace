class PagesController < ApplicationController
  def home
    @categories = Category.all
    @products = Product.in_stock.includes(:category, :user).order(created_at: :desc).limit(8)
  end
end
