class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy

  def admin?
    role == "admin"
  end

  def seller?
    role == "seller" || role == "admin"
  end
end
