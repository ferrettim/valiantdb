class RemoveNumberFromBooks < ActiveRecord::Migration
  def change
  	remove_column :books, :number
  	remove_column :books, :issue
  	remove_column :books, :date
  	add_column :books, :issue, :integer
  	add_column :books, :date, :date
  end
end
