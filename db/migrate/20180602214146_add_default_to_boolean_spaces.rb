class AddDefaultToBooleanSpaces < ActiveRecord::Migration[5.2]
  def change
    change_column :spaces, :is_wifi, :boolean, null: false, default: false
    change_column :spaces, :is_food, :boolean, null: false, default: false
    change_column :spaces, :is_alcohol, :boolean, null: false, default: false
    change_column :spaces, :is_catering, :boolean, null: false, default: false
    change_column :spaces, :is_kitchen, :boolean, null: false, default: false
    change_column :spaces, :is_accessible, :boolean, null: false, default: false
    change_column :spaces, :is_ground, :boolean, null: false, default: false
    change_column :spaces, :is_av, :boolean, null: false, default: false
    change_column :spaces, :is_natural, :boolean, null: false, default: false
  end
end
