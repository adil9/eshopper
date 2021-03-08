class AddProfileFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :phone, limit: 10
      t.string :first_name, limit: 100
      t.string :last_name, limit: 100
      t.integer :user_type, limit: 2, default: 1
      t.string :image_url
      t.decimal :lat, precision: 15, scale: 10
      t.decimal :long, precision: 15, scale: 10
      t.index :phone, unique: true
      t.index %i[lat long]
    end
  end
end
