class CreateItem < ActiveRecord::Migration[6.0]
  def change
    # MERGE ITEM_SHOP IN THIS
    create_table :items do |t|
      t.string :name, limit: 190
      t.text :description
      t.string :image_url
      t.integer :category, limit: 2
      t.decimal :display_price, precision: 13, scale: 2
      t.decimal :discounted_price, precision: 13, scale: 2
      t.decimal :tax, precision: 6, scale: 2
      t.integer :selling_stock
      t.integer :total_stock
      t.integer :shop_id
      t.timestamps
      t.index :name
      t.index %i[category shop_id]
      t.index :shop_id
    end
  end
end
