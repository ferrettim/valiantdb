class AddLettersToBooks < ActiveRecord::Migration
  def change
    add_column :books, :letters, :string
  end
end
