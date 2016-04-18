class AddIskeyToBooks < ActiveRecord::Migration
  def change
    add_column :books, :iskey, :boolean
  end
end
