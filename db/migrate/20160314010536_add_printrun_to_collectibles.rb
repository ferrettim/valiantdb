class AddPrintrunToCollectibles < ActiveRecord::Migration
  def change
    add_column :collectibles, :printrun, :integer
  end
end
