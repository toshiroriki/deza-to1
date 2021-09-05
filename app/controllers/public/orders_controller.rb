class Public::OrdersController < ApplicationController
    before_action :authenticate_customer!
  before_action :request_post?, only: [:confirm]

  def index
    @orders = current_customer.orders
  end

  def show
    @order = Order.find(params[:id]) #order特定
    @order_details = @order.order_details
    @total_price = 0
  end

  def new
    @customer = current_customer
    @i = current_customer.cart_items
    @all = Item.all
    @i.each do |item|
      @all = @all.where.not(id: item.item_id)
    end
    @item_random = @all.order("RANDOM()").limit(2)

    @order = Order.new
    @address = Address.new
  end

  def confirm
    params[:order][:payment] = params[:order][:payment].to_i #paymentの数値に変換
    @order = Order.new(order_params) #情報を渡している
  #分岐
    if params[:order][:address_number] == "1" #address_numberが　”1”　なら下記　ご自身の住所が選ばれたら
      @order.postal_code = current_customer.postal_code #自身の郵便番号をorderの郵便番号に入れる
      @order.address = current_customer.address #自身の住所をorderの住所に入れる
      @order.name = current_customer.last_name+current_customer.first_name #自身の宛名をorderの宛名に入れる

    elsif  params[:order][:address_number] ==  "2" #address_numberが　”2”　なら下記　登録済からの選択が選ばれたら
      @order.postal_code = Address.find(params[:order][:address_id]).postal_code #newページで選ばれた配送先住所idから特定して郵便番号の取得代入
      @order.address = Address.find(params[:order][:address_id]).address #newページで選ばれた配送先住所idから特定して住所の取得代入
      @order.name = Address.find(params[:order][:address_id]).name #newページで選ばれた配送先住所idから特定して宛名の取得代入

    elsif params[:order][:address_number] ==  "3" #address_numberが　”3”　なら下記　新しいお届け先が選ばれたら
      @address = Address.new() #変数の初期化
      @address.address = params[:order][:address] #newページで新しいお届け先に入力した住所を取得代入
      @address.name = params[:order][:name] #newページで新しいお届け先に入力した宛名を取得代入
      @address.postal_code = params[:order][:postal_code] #newページで新しいお届け先に入力した郵便番号を取得代入
      @address.customer_id = current_customer.id #newページで新しいお届け先に入力したmember_idを取得代入
      if @address.save #保存
      @order.postal_code = @address.postal_code #上記で代入された郵便番号をorderに代入
      @order.name = @address.name #上記で代入された宛名をorderに代入
      @order.address = @address.address #上記で代入された住所をorderに代入
      else
       render 'new'
       end
  end

    @cart_items = CartItem.where(customer_id: current_customer.id)
    #binding.pry
    @total_price = 0
  end


  def thanks
    #購入確定後のページ表示
  end

  def create
     params[:order][:payment] = params[:order][:payment].to_i
    @order = Order.new(order_params) #初期化代入
    @order.customer_id = current_customer.id #自身のidを代入
    @order.status = 0
    @order.save #orderに保存
#order_itmemの保存
current_customer.cart_items.each do |cart_item| #カートの商品を1つずつ取り出しループ
  @order_detail = OrderDetail.new #初期化宣言
  @order_detail.item_id = cart_item.item_id #商品idを注文商品idに代入
  @order_detail.amount = cart_item.amount #商品の個数を注文商品の個数に代入
  @order_detail.price = (cart_item.item.price*1.1).floor #消費税込みに計算して代入
  @order_detail.order_id =  @order.id #注文商品に注文idを紐付け
  @order_detail.save #注文商品を保存
end #ループ終わり

    current_customer.cart_items.destroy_all #カートの中身を削除
    redirect_to orders_thanks_path #thanksに遷移

end

  private

  def order_new?
    redirect_to cart_items_path, notice: "カートに商品を入れてください。" if current_customer.cart_items.blank?
  end

  def request_post?
    redirect_to new_order_path, notice: "もう一度最初から入力してください。" unless request.post?
  end

  def order_params
    params.require(:order).permit(:payment, :address, :postage, :postal_code, :name, :total_price, :address)
  end

  def address_params
    params.permit(:address, :name, :postal_code, :customer_id)
  end
end
