class FixUserBooksub < ActiveRecord::Migration[5.0]
  def change
    rename_column :booksubs, :user_id_id, :user_id
  end
end
