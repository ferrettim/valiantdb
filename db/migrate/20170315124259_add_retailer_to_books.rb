class AddRetailerToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :retailer, :string
  end
end
