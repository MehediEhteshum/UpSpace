class AddUserToUserPhotos < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_photos, :user, foreign_key: true
  end
end
