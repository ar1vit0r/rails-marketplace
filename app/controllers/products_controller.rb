class ProductsController < ApplicationController
  def index
    scope = Product.in_stock.includes(:category)
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
    scope = scope.where("name LIKE ?", "%#{params[:q]}%") if params[:q].present?
    @pagy, @products = pagy(scope.order(created_at: :desc), limit: 12)
  end

  def show
    @product = Product.includes(:category, :user).find(params[:id])
  end
end
