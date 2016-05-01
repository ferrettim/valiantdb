class AddWishcountsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wish_count, :integer, null:false, default: 0
  end
end
