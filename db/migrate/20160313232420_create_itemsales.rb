class CreateItemsales < ActiveRecord::Migration
  def change
    create_table :itemsales do |t|
      t.integer :user_id
      t.integer :item_id

      t.timestamps
    end
  end
end
