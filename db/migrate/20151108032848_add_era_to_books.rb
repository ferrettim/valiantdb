class AddEraToBooks < ActiveRecord::Migration
  def change
    add_column :books, :era, :string
  end
end
