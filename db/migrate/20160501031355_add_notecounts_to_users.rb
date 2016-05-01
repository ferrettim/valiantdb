class AddNotecountsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :note_count, :integer, null:false, default: 0
  end
end
