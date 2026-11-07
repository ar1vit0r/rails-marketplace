require "rails_helper"
require "ostruct"

RSpec.describe "Webhooks", type: :request do
  describe "POST /webhooks/stripe" do
    let(:order) { create(:order, status: "pending") }
    let(:checkout_session) do
      create(:checkout_session, order: order, stripe_session_id: "cs_test_123", status: "pending")
    end

    before { checkout_session }

    it "handles checkout.session.completed" do
      event = OpenStruct.new(
        type: "checkout.session.completed",
        data: OpenStruct.new(
          object: OpenStruct.new(id: "cs_test_123", payment_intent: "pi_test_456")
        )
      )

      allow(Stripe::Webhook).to receive(:construct_event).and_return(event)

      post webhooks_stripe_path,
           params: "{}",
           headers: { "CONTENT_TYPE" => "application/json", "HTTP_STRIPE_SIGNATURE" => "test_sig" }

      expect(response).to have_http_status(:ok)
      expect(checkout_session.reload.status).to eq("paid")
      expect(checkout_session.payment_intent_id).to eq("pi_test_456")
      expect(order.reload.status).to eq("paid")
    end

    it "records payment but does not regress an order that is no longer pending" do
      order.update!(status: "shipped")
      event = OpenStruct.new(
        type: "checkout.session.completed",
        data: OpenStruct.new(object: OpenStruct.new(id: "cs_test_123", payment_intent: "pi_late"))
      )
      allow(Stripe::Webhook).to receive(:construct_event).and_return(event)

      post webhooks_stripe_path,
           params: "{}",
           headers: { "CONTENT_TYPE" => "application/json", "HTTP_STRIPE_SIGNATURE" => "test_sig" }

      expect(checkout_session.reload.status).to eq("paid")
      expect(order.reload.status).to eq("shipped")
    end

    it "handles checkout.session.expired" do
      event = OpenStruct.new(
        type: "checkout.session.expired",
        data: OpenStruct.new(
          object: OpenStruct.new(id: "cs_test_123")
        )
      )

      allow(Stripe::Webhook).to receive(:construct_event).and_return(event)

      post webhooks_stripe_path,
           params: "{}",
           headers: { "CONTENT_TYPE" => "application/json", "HTTP_STRIPE_SIGNATURE" => "test_sig" }

      expect(response).to have_http_status(:ok)
      expect(checkout_session.reload.status).to eq("expired")
    end

    context "when a checkout expires on a pending order" do
      let(:product) { create(:product, stock: 3) }
      let(:event) do
        OpenStruct.new(
          type: "checkout.session.expired",
          data: OpenStruct.new(object: OpenStruct.new(id: "cs_test_123"))
        )
      end

      before do
        create(:order_item, order: order, product: product, quantity: 2, price: 10)
        allow(Stripe::Webhook).to receive(:construct_event).and_return(event)
      end

      def send_expired
        post webhooks_stripe_path,
             params: "{}",
             headers: { "CONTENT_TYPE" => "application/json", "HTTP_STRIPE_SIGNATURE" => "test_sig" }
      end

      it "cancels the order and gives its stock back" do
        send_expired

        expect(order.reload.status).to eq("cancelled")
        expect(product.reload.stock).to eq(5)
      end

      it "restores stock only once when the event is replayed" do
        2.times { send_expired }

        expect(product.reload.stock).to eq(5)
      end

      it "keeps the order and stock while another checkout session is still open" do
        create(:checkout_session, order: order, status: "pending")

        send_expired

        expect(order.reload.status).to eq("pending")
        expect(product.reload.stock).to eq(3)
      end
    end

    it "does not let a late expired event overwrite a paid checkout" do
      checkout_session.update!(status: "paid")
      event = OpenStruct.new(
        type: "checkout.session.expired",
        data: OpenStruct.new(object: OpenStruct.new(id: "cs_test_123"))
      )
      allow(Stripe::Webhook).to receive(:construct_event).and_return(event)

      post webhooks_stripe_path,
           params: "{}",
           headers: { "CONTENT_TYPE" => "application/json", "HTTP_STRIPE_SIGNATURE" => "test_sig" }

      expect(response).to have_http_status(:ok)
      expect(checkout_session.reload.status).to eq("paid")
    end

    it "returns bad request for invalid signature" do
      allow(Stripe::Webhook).to receive(:construct_event).and_raise(
        Stripe::SignatureVerificationError.new("invalid", "sig")
      )

      post webhooks_stripe_path,
           params: "{}",
           headers: { "CONTENT_TYPE" => "application/json", "HTTP_STRIPE_SIGNATURE" => "bad_sig" }

      expect(response).to have_http_status(:bad_request)
    end
  end
end
