class AddImageRemoteUrlToBooks < ActiveRecord::Migration
  def change
    add_column :books, :image_remote_link, :string
  end
end
