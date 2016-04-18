class AddCgc98ToBooks < ActiveRecord::Migration
  def change
    add_column :books, :price98, :integer
  end
end
