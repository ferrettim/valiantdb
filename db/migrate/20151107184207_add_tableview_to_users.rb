class AddTableviewToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tableview, :boolean, :default => false
  end
end
