class AddSqftToSpaces < ActiveRecord::Migration[5.2]
  def change
    add_column :spaces, :sqft, :integer
  end
end
