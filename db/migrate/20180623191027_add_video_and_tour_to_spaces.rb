class AddVideoAndTourToSpaces < ActiveRecord::Migration[5.2]
  def change
    add_column :spaces, :video_embed, :string
    add_column :spaces, :tour_embed, :string
  end
end
