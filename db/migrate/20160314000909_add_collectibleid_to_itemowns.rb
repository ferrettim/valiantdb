class AddCollectibleidToItemowns < ActiveRecord::Migration
  def change
    add_column :itemowns, :collectible_id, :integer
  end
end
