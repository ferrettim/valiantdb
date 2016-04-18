class AddQrToBooks < ActiveRecord::Migration
  def change
    add_column :books, :qr, :string
  end
end
