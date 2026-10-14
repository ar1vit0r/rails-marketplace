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

    it "filters by category and marks it as current" do
      lamp = create(:product, name: "Desk Lamp", category: create(:category, name: "Lighting"))
      create(:product, name: "Paperback", category: create(:category, name: "Reading"))
      get products_path(category_id: lamp.category_id)
      expect(response.body).to include("Desk Lamp", 'aria-current="true"')
      expect(response.body).not_to include("Paperback")
    end

    it "shows an empty state with a way out of the filters" do
      get products_path(q: "no-such-product")
      expect(response.body).to include("No products found", "Clear filters")
    end

    it "paginates 12 per page and keeps the filters in the page links" do
      category = create(:category)
      25.times { |i| create(:product, name: "Product #{i}", category: category) }
      filters = { q: "Product", category_id: category.id }

      get products_path(filters)
      expect(response.body.scan("bg-plate aspect-square").size).to eq(12)
      expect(response.body).to include("category_id=#{category.id}&amp;page=2&amp;q=Product")
      expect(response.body).not_to include("Previous page")

      get products_path(filters.merge(page: 2))
      expect(response.body).to include("category_id=#{category.id}&amp;page=1&amp;q=Product")
      expect(response.body).to include("category_id=#{category.id}&amp;page=3&amp;q=Product")
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
