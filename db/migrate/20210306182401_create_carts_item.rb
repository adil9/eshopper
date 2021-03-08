class CreateCartsItem < ActiveRecord::Migration[6.0]
  def change
    create_table :carts do |t|
      t.integer :user_id
      t.integer :status, limit: 2, default: 3
      t.timestamps
      t.index :user_id, unique: true
    end
    create_table :carts_items do |t|
      t.integer :item_id
      t.integer :cart_id
      t.integer :quantity, default: 0
      t.integer :status, limit: 2
      t.decimal :discount, precision: 13, scale: 2
      t.decimal :price, precision: 13, scale: 2
      t.decimal :tax, precision: 6, scale: 2
      t.timestamps
      t.index %i[cart_id status]
    end
  end
end
