class RenameLongitudeColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :long, :lng
    rename_column :shops, :long, :lng
  end
end
