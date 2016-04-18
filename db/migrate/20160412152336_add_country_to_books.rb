class AddCountryToBooks < ActiveRecord::Migration
  def change
    add_column :books, :country, :string
  end
end
