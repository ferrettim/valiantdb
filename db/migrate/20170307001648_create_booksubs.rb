class CreateBooksubs < ActiveRecord::Migration[5.0]
  def change
    create_table :booksubs do |t|
      t.references :user_id
      t.string :book_title
      t.timestamps
    end
  end
end
