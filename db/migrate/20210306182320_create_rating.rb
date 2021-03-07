class CreateRating < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :shop_id
      t.float :rating
      t.text :description
      t.timestamps
      t.index :shop_id
    end
  end
end
