class AddInstantToSpaces < ActiveRecord::Migration[5.1]
  def change
    add_column :spaces, :instant, :integer, default: 1
  end
end
