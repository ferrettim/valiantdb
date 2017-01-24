class CreatePolls < ActiveRecord::Migration[5.0]
  def change
    create_table :polls do |t|
      t.text :topic
      t.string :image1
      t.string :image2
      t.string :image3

      t.timestamps
    end
  end
end
