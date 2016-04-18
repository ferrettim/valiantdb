class CreateItemwishes < ActiveRecord::Migration
  def change
    create_table :itemwishes do |t|
      t.integer :user_id
      t.integer :item_id

      t.timestamps
    end
  end
end
