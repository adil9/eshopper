class CreateInvoice < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.decimal :base_price, precision: 13, scale: 2
      t.decimal :delivery_charges, precision: 13, scale: 2
      t.decimal :tax_charges, precision: 13, scale: 2
      t.integer :order_id
      t.string :address_line1
      t.string :address_line2
      t.string :landmark
      t.string :zip_code, limit: 20
      t.timestamps
      t.index :order_id
    end
  end
end
