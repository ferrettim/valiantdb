class AddEicToBooks < ActiveRecord::Migration
  def change
    add_column :books, :eic, :string
  end
end
