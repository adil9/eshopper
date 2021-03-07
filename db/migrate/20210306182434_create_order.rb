class CreateOrder < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :shop_id
      t.integer :user_id
      t.integer :delivery_person_id
      t.string :order_no, limit: 36
      t.integer :status, limit: 2
      t.string :promo_code, limit: 40
      # This column basically should go to Payment related schema.
      t.integer :payment_method, limit: 2
      t.timestamps
      t.index :user_id
      t.index :order_no
      t.index :shop_id
      t.index :delivery_person_id
    end
  end
end
