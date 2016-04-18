class AddBookcodeToBooks < ActiveRecord::Migration
  def change
    add_column :books, :bookcode, :string
  end
end
