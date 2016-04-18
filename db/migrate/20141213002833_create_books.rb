class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :number
      t.string :title
      t.string :date
      t.string :note

      t.timestamps
    end
  end
end
