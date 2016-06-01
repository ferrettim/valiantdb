class Add < ActiveRecord::Migration
  def change
    add_column :books, :comicrating, :string
  end
end
