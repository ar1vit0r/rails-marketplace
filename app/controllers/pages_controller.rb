class PagesController < ApplicationController
  def home
    @categories = Category.all
    @products = Product.includes(:category).limit(8)
  end
end
