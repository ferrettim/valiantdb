class FixCountsForUsers < ActiveRecord::Migration
  def change
  	rename_column :users, :wish_count, :wishes_count
  	rename_column :users, :sell_count, :sales_count
  	rename_column :users, :note_count, :comments_count
  end
end
