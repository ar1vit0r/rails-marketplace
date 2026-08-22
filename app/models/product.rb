class Product < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :in_stock, -> { where("stock > 0") }
end
