class Item < ApplicationRecord
  attachment :image
  has_many :cart_items
	has_many :order_details
	belongs_to :genre


  # バリデーション
  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true
end
