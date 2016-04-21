class AddOwncountsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :owns_count, :integer, null:false, default: 0
  end
end