class OrderDetail < ApplicationRecord
  belongs_to :order
	belongs_to :item
	enum maiking_status: [:着手不可,:製作待ち,:製作中,:製作完了]

end
