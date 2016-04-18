class RemovePatronLevelsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :patron1, :boolean
    remove_column :users, :patron3, :boolean
    remove_column :users, :patron5, :boolean
    remove_column :users, :patron20, :boolean
  end
end
