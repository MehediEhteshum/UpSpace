class AddPositionToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :sort, :integer
  end
end
