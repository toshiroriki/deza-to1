class CreateAdminOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_orders do |t|
      t.integer :customer_id
    	t.integer :postage
    	t.integer :payment
    	t.string :address
    	t.string :postal_code
    	t.string :name
    	t.integer :total_price
    	t.integer :status
      t.timestamps
    end
  end
end
