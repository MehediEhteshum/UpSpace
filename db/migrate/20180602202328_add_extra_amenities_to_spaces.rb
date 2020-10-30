class AddExtraAmenitiesToSpaces < ActiveRecord::Migration[5.2]
  def change
    add_column :spaces, :is_alcohol, :boolean
    add_column :spaces, :is_catering, :boolean
    add_column :spaces, :is_kitchen, :boolean
    add_column :spaces, :is_ground, :boolean
    add_column :spaces, :is_av, :boolean
    add_column :spaces, :is_natural, :boolean
  end
end
