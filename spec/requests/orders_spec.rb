require "rails_helper"

RSpec.describe "Orders", type: :request do
  let(:user) { create(:user) }

  describe "POST /orders" do
    context "when logged in" do
      before { sign_in user }

      it "creates an order" do
        product = create(:product)
        post cart_add_path(product)

        expect {
          post orders_path
        }.to change(Order, :count).by(1)
        expect(response).to redirect_to(order_path(Order.last))
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        post orders_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
