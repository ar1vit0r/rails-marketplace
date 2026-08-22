require "rails_helper"

RSpec.describe User, type: :model do
  describe "factory" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end

    it "has a valid admin factory" do
      expect(build(:user, :admin)).to be_valid
    end

    it "has a valid seller factory" do
      expect(build(:user, :seller)).to be_valid
    end
  end

  describe "#admin?" do
    it "returns true for admin users" do
      expect(build(:user, :admin).admin?).to be true
    end

    it "returns false for regular users" do
      expect(build(:user).admin?).to be false
    end
  end

  describe "#seller?" do
    it "returns true for sellers" do
      expect(build(:user, :seller).seller?).to be true
    end

    it "returns true for admins" do
      expect(build(:user, :admin).seller?).to be true
    end

    it "returns false for regular users" do
      expect(build(:user).seller?).to be false
    end
  end
end
