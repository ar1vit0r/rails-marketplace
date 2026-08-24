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
  end
end
