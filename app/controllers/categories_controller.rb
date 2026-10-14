class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @pagy, @products = pagy(@category.products.in_stock.order(created_at: :desc), limit: 12)
  end
end
