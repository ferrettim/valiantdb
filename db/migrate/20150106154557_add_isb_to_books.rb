class AddIsbToBooks < ActiveRecord::Migration
  def change
    add_column :books, :isb, :string
  end
end
