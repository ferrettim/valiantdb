class AddRatioToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :ratio, :string
  end
end
