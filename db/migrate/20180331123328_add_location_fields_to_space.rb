class AddLocationFieldsToSpace < ActiveRecord::Migration[5.1]
  def change
    add_column :spaces, :latitude, :float
    add_column :spaces, :longitude, :float
  end
end
