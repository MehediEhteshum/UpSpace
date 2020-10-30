class RenameListingType < ActiveRecord::Migration[5.1]
  def change
    rename_column :spaces, :type, :listing_type
    rename_column :spaces, :category, :listing_category
  end
end
