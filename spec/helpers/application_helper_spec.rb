require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#category_hue" do
    it "gives 360 consecutive ids 360 distinct hues within 0..359" do
      hues = (1..360).map { |id| helper.category_hue(id) }
      expect(hues).to all(be_between(0, 359))
      expect(hues.uniq.size).to eq(360)
    end
  end
end
