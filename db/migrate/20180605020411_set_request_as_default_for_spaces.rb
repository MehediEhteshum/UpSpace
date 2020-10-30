class SetRequestAsDefaultForSpaces < ActiveRecord::Migration[5.2]
  def change
    change_column :spaces, :instant, :integer, default: 0
  end
end
