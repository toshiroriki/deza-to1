class Public::CartItemsController < ApplicationController
    before_action :authenticate_customer!
 before_action :cart_item_item?, only: [:create]

  def index
    @cart_items = current_customer.cart_items
    @total_price = 0

  end

  def create
	if current_customer.cart_items.count >= 1
	  if nil != current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
		   @cart_item_u = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
		   @cart_item_u.amount += params[:cart_item][:amount].to_i
		   @cart_item_u.update(amount: @cart_item_u.amount) #
		   redirect_to cart_items_path
		 else
			 	@cart_item = CartItem.new(cart_item_params)
			@cart_item.customer_id = current_customer.id
			if @cart_item.save
				 redirect_to cart_items_path
			else
				@items = Item.all
		    @quantity = Item.count
		    @genres = Genre.all
				render 'index'
		end
  end

	else
		@cart_item = CartItem.new(cart_item_params)
		@cart_item.customer_id = current_customer.id
		if @cart_item.save
			 redirect_to cart_items_path
		else
			@items = Item.all
	    @quantity = Item.count
	    @genres = Genre.all
			render 'index'
		end

	end
   end

	def update
		@cart_item = CartItem.find(params[:id])
		@cart_item.update(cart_item_params)
		redirect_to cart_items_path
	end

	def destroy
		@cart_item = CartItem.find(params[:id])
		@cart_item.destroy
		redirect_to cart_items_path
	end

	def destroy_all
		@cart_items = current_customer.cart_items
		@cart_items.destroy_all
		redirect_to cart_items_path
	end

	private

	def cart_item_item?
		redirect_to item_path(params[:cart_item][:item_id]), notice: "個数を入力してください。" if params[:cart_item][:amount].empty?
	end

	def cart_item_params
		params.require(:cart_item).permit(:item_id, :amount,:customer_id)
	end
end
