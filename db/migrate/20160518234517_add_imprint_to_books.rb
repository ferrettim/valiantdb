class AddImprintToBooks < ActiveRecord::Migration
  def change
    add_column :books, :imprint, :string
  end
end
