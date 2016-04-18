class AddEditorToBooks < ActiveRecord::Migration
  def change
    add_column :books, :editor, :string
  end
end
