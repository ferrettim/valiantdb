class AddScoreAndLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :score, :integer, :default => 0
    add_column :users, :level_id, :integer
  end
  def self.down
  	remove_column :users, :score
  	remove_column :users, :level_id
  end
end
