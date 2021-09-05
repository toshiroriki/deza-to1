class Admin::OrderDetailsController < ApplicationController
    before_action :authenticate_admin!

	def update
		@order_detail = OrderDetail.find(params[:id])
		@order = @order_detail.order
		@order_detail.update(order_details_params)

		if @order_detail.maiking_status == "製作中"
			@order.update(status: 2)
		elsif @order.order_details.count == @order.order_details.where(maiking_status: "製作完了").count
			@order.update(status: 3)
	    end
		redirect_to admin_order_path(@order_detail.order) #注文詳細に遷移
	end

	private

	def order_details_params
      params.require(:order_detail).permit(:maiking_status)
        end

end
