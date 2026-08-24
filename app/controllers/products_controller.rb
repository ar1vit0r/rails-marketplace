class ProductsController < ApplicationController
  def index
    scope = Product.in_stock.includes(:category, :user)
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
    scope = scope.where("name LIKE ?", "%#{params[:q]}%") if params[:q].present?
    @pagy, @products = pagy(scope.order(created_at: :desc), items: 12)
  end

  def show
    @product = Product.includes(:category, :user).find(params[:id])
  end
end
