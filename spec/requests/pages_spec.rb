require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:ok)
    end

    it "lists categories and products" do
      category = create(:category, name: "Gadgets")
      create(:product, name: "Desk Lamp", category: category)
      get root_path
      expect(response.body).to include("Gadgets", "Desk Lamp")
    end

    it "shows an empty state without products" do
      get root_path
      expect(response.body).to include("No products yet")
    end
  end
end
