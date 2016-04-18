class AddWriter2ToBooks < ActiveRecord::Migration
  def change
    add_column :books, :writer2, :string
  end
end
