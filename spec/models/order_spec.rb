require "rails_helper"

RSpec.describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of(:status) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:order_items).dependent(:destroy) }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:order)).to be_valid
    end
  end
end
