class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @pagy, @products = pagy(@category.products.in_stock.includes(:user).order(created_at: :desc), items: 12)
  end
end
