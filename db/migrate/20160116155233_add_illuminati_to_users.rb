class AddIlluminatiToUsers < ActiveRecord::Migration
  def change
    add_column :users, :illuminati, :boolean
  end
end
