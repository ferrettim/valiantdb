class AddLevelsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :level1, :boolean
    add_column :users, :level3, :boolean
    add_column :users, :level5, :boolean
    add_column :users, :level20, :boolean
  end
end
