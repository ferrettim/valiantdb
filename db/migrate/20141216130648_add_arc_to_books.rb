class AddArcToBooks < ActiveRecord::Migration
  def change
    add_column :books, :arc, :string
  end
end
