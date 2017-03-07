class AddFieldsToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :grade, :string
    add_column :comments, :cgcgrade, :string
    add_column :comments, :grader, :string
    add_column :comments, :signature, :boolean
  end
end
