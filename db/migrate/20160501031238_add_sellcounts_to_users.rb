class AddSellcountsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sell_count, :integer, null:false, default: 0
  end
end
