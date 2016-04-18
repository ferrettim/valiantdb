class AddArtistToBooks < ActiveRecord::Migration
  def change
    add_column :books, :artist, :string
  end
end
