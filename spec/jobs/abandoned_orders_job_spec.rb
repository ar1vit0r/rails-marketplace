require "rails_helper"

RSpec.describe AbandonedOrdersJob, type: :job do
  let(:product) { create(:product, stock: 3) }

  def order_with_item(created_at:, status: "pending")
    create(:order, status: status, created_at: created_at).tap do |order|
      create(:order_item, order: order, product: product, quantity: 2, price: 10)
    end
  end

  it "cancels old pending orders that never started checkout and restores their stock" do
    order = order_with_item(created_at: 3.hours.ago)

    described_class.perform_now

    expect(order.reload.status).to eq("cancelled")
    expect(product.reload.stock).to eq(5)
  end

  it "leaves recent pending orders alone" do
    order = order_with_item(created_at: 10.minutes.ago)

    described_class.perform_now

    expect(order.reload.status).to eq("pending")
    expect(product.reload.stock).to eq(3)
  end

  it "leaves old orders with an open checkout session to the Stripe expiry webhook" do
    order = order_with_item(created_at: 3.hours.ago)
    create(:checkout_session, order: order, status: "pending")

    described_class.perform_now

    expect(order.reload.status).to eq("pending")
    expect(product.reload.stock).to eq(3)
  end

  it "leaves paid orders alone" do
    order = order_with_item(created_at: 3.hours.ago, status: "paid")

    described_class.perform_now

    expect(order.reload.status).to eq("paid")
    expect(product.reload.stock).to eq(3)
  end

  it "restores stock only once when run twice" do
    order_with_item(created_at: 3.hours.ago)

    2.times { described_class.perform_now }

    expect(product.reload.stock).to eq(5)
  end
end
