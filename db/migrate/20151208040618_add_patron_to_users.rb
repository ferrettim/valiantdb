class AddPatronToUsers < ActiveRecord::Migration
  def change
    add_column :users, :patron, :boolean
  end
end
