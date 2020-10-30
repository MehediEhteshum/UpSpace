class RenameUserPhotosToAvatars < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_photos, :avatars
  end
end
