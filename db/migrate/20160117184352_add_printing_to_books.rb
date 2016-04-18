class AddPrintingToBooks < ActiveRecord::Migration
  def change
    add_column :books, :printing, :integer
  end
end
