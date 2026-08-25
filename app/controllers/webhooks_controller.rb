class WebhooksController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = ENV["STRIPE_WEBHOOK_SECRET"]

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError
      head :bad_request
      return
    rescue Stripe::SignatureVerificationError
      head :bad_request
      return
    end

    case event.type
    when "checkout.session.completed"
      handle_checkout_completed(event.data.object)
    when "checkout.session.expired"
      handle_checkout_expired(event.data.object)
    end

    head :ok
  end

  private

  def handle_checkout_completed(session)
    checkout = CheckoutSession.find_by(stripe_session_id: session.id)
    return unless checkout

    checkout.update!(
      status: "paid",
      payment_intent_id: session.payment_intent
    )
    checkout.order.update!(status: "paid")
  end

  def handle_checkout_expired(session)
    checkout = CheckoutSession.find_by(stripe_session_id: session.id)
    return unless checkout

    checkout.update!(status: "expired")
  end
end
