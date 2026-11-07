require "rails_helper"

RSpec.describe "Cart", type: :request do
  describe "GET /cart" do
    it "returns http success" do
      get cart_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /cart/add/:product_id" do
    it "adds product to cart" do
      product = create(:product)
      expect {
        post cart_add_path(product)
      }.to change(CartItem, :count).by(1)
      expect(response).to redirect_to(cart_path)
    end

    it "refuses to add more than the available stock" do
      product = create(:product, stock: 1)
      post cart_add_path(product)

      expect {
        post cart_add_path(product)
      }.not_to change { CartItem.sum(:quantity) }
      expect(flash[:alert]).to be_present
    end

    it "refuses an out-of-stock product" do
      product = create(:product, stock: 0)

      expect {
        post cart_add_path(product)
      }.not_to change(CartItem, :count)
      expect(flash[:alert]).to be_present
    end
  end

  describe "stale cart in session" do
    it "recovers when the cart row was deleted" do
      post cart_add_path(create(:product))
      Cart.destroy_all

      get cart_path
      expect(response).to have_http_status(:ok)
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end
end
