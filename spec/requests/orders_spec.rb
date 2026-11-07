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

    context "when logged in and stock is limited" do
      before { sign_in user }

      it "decrements stock by the ordered quantity" do
        product = create(:product, stock: 5)
        2.times { post cart_add_path(product) }

        post orders_path

        expect(product.reload.stock).to eq(3)
      end

      it "rolls back earlier decrements when a later line is out of stock" do
        plenty = create(:product, stock: 5)
        scarce = create(:product, stock: 2)
        post cart_add_path(plenty)
        2.times { post cart_add_path(scarce) }
        scarce.update!(stock: 1)

        expect { post orders_path }.not_to change(Order, :count)
        expect(plenty.reload.stock).to eq(5)
        expect(scarce.reload.stock).to eq(1)
        expect(response).to redirect_to(cart_path)
      end
    end

    context "when logged in with nothing orderable" do
      before { sign_in user }

      it "rejects an empty cart" do
        expect { post orders_path }.not_to change(Order, :count)
        expect(response).to redirect_to(cart_path)
      end

      it "rejects a cart that exceeds stock and creates nothing" do
        product = create(:product, stock: 2)
        post cart_add_path(product)
        post cart_add_path(product)
        product.update!(stock: 1)

        expect { post orders_path }.not_to change { [ Order.count, OrderItem.count ] }
        expect(response).to redirect_to(cart_path)
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
