require "rails_helper"

RSpec.describe "Products", type: :request do
  describe "GET /products" do
    it "returns http success" do
      get products_path
      expect(response).to have_http_status(:ok)
    end

    it "displays products" do
      product = create(:product)
      get products_path
      expect(response.body).to include(product.name)
    end
  end

  describe "GET /products/:id" do
    it "returns http success" do
      product = create(:product)
      get product_path(product)
      expect(response).to have_http_status(:ok)
    end
  end
end
