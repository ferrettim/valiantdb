class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.attachment :image
      t.string :creator
      t.string :creator2
      t.string :apptitle
      t.integer :appissue
      t.string :appera
      t.text :origin
      t.string :power
      t.string :power2
      t.string :power3
      t.string :power4
      t.string :power5

      t.timestamps
    end
  end
end
