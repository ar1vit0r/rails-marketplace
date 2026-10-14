module ApplicationHelper
  include Pagy::NumericHelpers

  # Stable hue (0-359) per category id; 67 is coprime with 360 so neighbouring ids spread out.
  def category_hue(category_id)
    (category_id * 67) % 360
  end
end
