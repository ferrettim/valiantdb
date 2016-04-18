class AddPrintrunToBooks < ActiveRecord::Migration
  def change
    add_column :books, :printrun, :integer
  end
end
