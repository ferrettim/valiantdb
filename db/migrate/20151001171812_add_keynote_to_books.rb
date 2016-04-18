class AddKeynoteToBooks < ActiveRecord::Migration
  def change
    add_column :books, :keynote, :text
  end
end
