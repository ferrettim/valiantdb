class AddCollectibleidToItemsales < ActiveRecord::Migration
  def change
    add_column :itemsales, :collectible_id, :integer
  end
end
