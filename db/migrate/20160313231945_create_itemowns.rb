class CreateItemowns < ActiveRecord::Migration
  def change
    create_table :itemowns do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :quantity

      t.timestamps
    end
  end
end
