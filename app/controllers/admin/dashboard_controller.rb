class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @products = Product.count
    @orders = Order.count
    @users = User.count
    @recent_orders = Order.includes(:user).order(created_at: :desc).limit(10)
  end

  private

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end
end
