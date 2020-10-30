class AddFeaturedToSpaces < ActiveRecord::Migration[5.2]
  def change
    add_column :spaces, :featured, :boolean, null: false, default: false
  end
end
