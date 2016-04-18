class AddColorsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :colors, :string
  end
end
