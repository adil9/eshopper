class CreateShop < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.string :name, limit: 190
      t.text :description
      t.decimal :lat, precision: 15, scale: 10
      t.decimal :long, precision: 15, scale: 10
      t.string :image_url
      t.float :rating
      t.integer :user_id
      t.timestamps
      # Keeping user_id index as non unique as one user might have multiple shops in the city
      t.index :name
      t.index :user_id, unique: false
      t.index %i[lat long]
    end
  end
end
