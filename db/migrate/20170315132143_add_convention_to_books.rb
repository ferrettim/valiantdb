class AddConventionToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :convention, :string
  end
end
