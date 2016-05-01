class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :text
      t.integer :points
      t.timestamps
    end
  end
  def self.down
  	drop_table :events
  end
end
