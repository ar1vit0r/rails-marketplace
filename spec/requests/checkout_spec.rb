require "rails_helper"

RSpec.describe "Checkout", type: :request do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  describe "POST /orders/:order_id/checkout" do
    context "when logged in" do
      before { sign_in user }

      it "creates a Stripe checkout session and redirects" do
        order = create(:order, user: user, status: "pending", total: 25.00)
        create(:order_item, order: order, product: product, price: 25.00, quantity: 1)

        mock_session = double(id: "cs_test_123", url: "https://checkout.stripe.com/test")
        allow(Stripe::Checkout::Session).to receive(:create).and_return(mock_session)

        post order_checkout_path(order)

        expect(response).to have_http_status(:see_other)
        expect(response.location).to eq("https://checkout.stripe.com/test")
        expect(order.checkout_session).to be_present
        expect(order.checkout_session.stripe_session_id).to eq("cs_test_123")
      end

      it "keeps the earlier checkout session when the order is submitted twice" do
        order = create(:order, user: user, status: "pending", total: 25.00)
        create(:order_item, order: order, product: product, price: 25.00, quantity: 1)
        allow(Stripe::Checkout::Session).to receive(:create).and_return(
          double(id: "cs_first", url: "https://checkout.stripe.com/1"),
          double(id: "cs_second", url: "https://checkout.stripe.com/2")
        )

        post order_checkout_path(order)
        post order_checkout_path(order)

        expect(CheckoutSession.where(order: order).pluck(:stripe_session_id)).to contain_exactly("cs_first", "cs_second")
      end

      it "does not start checkout for a cancelled order" do
        order = create(:order, user: user, status: "cancelled")
        expect(Stripe::Checkout::Session).not_to receive(:create)

        post order_checkout_path(order)

        expect(response).to redirect_to(order)
      end

      it "redirects with an alert when Stripe fails" do
        order = create(:order, user: user, status: "pending", total: 25.00)
        create(:order_item, order: order, product: product, price: 25.00, quantity: 1)
        allow(Stripe::Checkout::Session).to receive(:create).and_raise(Stripe::APIConnectionError.new("down"))

        post order_checkout_path(order)

        expect(response).to redirect_to(order)
        expect(flash[:alert]).to be_present
      end

      it "redirects if order is already paid" do
        order = create(:order, user: user, status: "paid")

        post order_checkout_path(order)

        expect(response).to redirect_to(order)
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        order = create(:order, status: "pending")
        post order_checkout_path(order)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /checkout/success" do
    context "when logged in" do
      before { sign_in user }

      it "redirects to order with success notice" do
        order = create(:order, user: user)
        get checkout_success_path(order_id: order.id)
        expect(response).to redirect_to(order)
      end
    end
  end

  describe "GET /checkout/cancel" do
    context "when logged in" do
      before { sign_in user }

      it "redirects to order with cancel notice" do
        order = create(:order, user: user)
        get checkout_cancel_path(order_id: order.id)
        expect(response).to redirect_to(order)
      end
    end
  end
end
