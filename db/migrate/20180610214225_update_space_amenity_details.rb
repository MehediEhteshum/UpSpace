class UpdateSpaceAmenityDetails < ActiveRecord::Migration[5.2]
  def change
    rename_column :spaces, :is_av, :is_audio
    add_column :spaces, :is_byob, :boolean, null: false, default: false
    add_column :spaces, :is_video, :boolean, null: false, default: false
  end
end
