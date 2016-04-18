class AddQuantityToOwns < ActiveRecord::Migration
  def change
    add_column :owns, :quantity, :integer
  end
end
