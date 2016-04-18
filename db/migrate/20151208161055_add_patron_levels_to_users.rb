class AddPatronLevelsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :patron1, :boolean
  	add_column :users, :patron3, :boolean
  	add_column :users, :patron5, :boolean
  	add_column :users, :patron20, :boolean
  end
end
