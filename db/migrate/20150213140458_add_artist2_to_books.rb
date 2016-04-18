class AddArtist2ToBooks < ActiveRecord::Migration
  def change
    add_column :books, :artist2, :string
  end
end
