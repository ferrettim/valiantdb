class AddNmToBooks < ActiveRecord::Migration
  def change
    add_column :books, :pricenm, :integer
  end
end
