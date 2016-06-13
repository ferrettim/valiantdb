class AddAttachmentImageToPreviews < ActiveRecord::Migration
  def self.up
    change_table :previews do |t|

      t.attachment :image

    end
  end

  def self.down

    remove_attachment :previews, :image

  end
end
