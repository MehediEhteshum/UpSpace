class AddAvailabilityTextToSpaces < ActiveRecord::Migration[5.2]
  def change
    add_column :spaces, :availability_text, :text
  end
end
