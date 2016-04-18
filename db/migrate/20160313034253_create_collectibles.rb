class CreateCollectibles < ActiveRecord::Migration
  def change
    create_table :collectibles do |t|
      t.string :title
      t.date :rdate
      t.text :description
      t.string :category
      t.string :manufacturer
      t.text :link
      t.string :slug
      t.integer :price
    end
  end
end
