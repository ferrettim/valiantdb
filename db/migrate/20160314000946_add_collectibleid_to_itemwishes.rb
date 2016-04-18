class AddCollectibleidToItemwishes < ActiveRecord::Migration
  def change
    add_column :itemwishes, :collectible_id, :integer
  end
end
