class AddEventpartToBooks < ActiveRecord::Migration
  def change
    add_column :books, :eventpart, :integer
  end
end
