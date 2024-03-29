class AddAttachmentImageToUserPhotos < ActiveRecord::Migration[5.2]
  def self.up
    change_table :user_photos do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :user_photos, :image
  end
end
