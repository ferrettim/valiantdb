class AddAttachmentImageToCollectibles < ActiveRecord::Migration
  def self.up
    change_table :collectibles do |t|

      t.attachment :image

    end
  end

  def self.down

    remove_attachment :collectibles, :image

  end
end
