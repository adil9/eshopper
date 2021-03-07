class CreateOrdersItem < ActiveRecord::Migration[6.0]
  def change
    create_table :orders_items do |t|
      t.integer :item_id
      t.integer :order_id
      t.integer :quantity
      t.decimal :discount, precision: 13, scale: 2
      t.decimal :price, precision: 13, scale: 2
      t.decimal :tax, precision: 6, scale: 2
      t.timestamps
      t.index :order_id
    end
  end
end
