class AddRdateToBooks < ActiveRecord::Migration
  def change
    add_column :books, :rdate, :date
  end
end
