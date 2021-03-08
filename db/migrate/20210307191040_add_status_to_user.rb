class AddStatusToUser < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :status, :integer, limit: 2, default: 1
    add_column :orders_items, :status, :integer, limit: 2, default: 1
    change_column  :shops, :rating, :float, default: 0
    change_column  :ratings, :rating, :float, default: 0
  end

  def down
    remove_column :users, :status
    remove_column :orders_items, :status
    change_column  :shops, :rating, :float
    change_column  :ratings, :rating, :float
  end
end
