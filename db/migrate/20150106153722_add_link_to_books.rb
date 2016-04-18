class AddLinkToBooks < ActiveRecord::Migration
  def change
    add_column :books, :link, :text
  end
end
