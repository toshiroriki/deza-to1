class Address < ApplicationRecord
    	# アソシエーション
  belongs_to :customer

  # バリデーション
  validates :postal_code, :address, :name, presence: true


	def address_all
    self.postal_code+" "+self.address+" "+self.name
  end
end
