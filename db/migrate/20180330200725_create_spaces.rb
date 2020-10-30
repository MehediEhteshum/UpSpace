class CreateSpaces < ActiveRecord::Migration[5.1]
  def change
    create_table :spaces do |t|
      t.string :title
      t.string :type
      t.string :category
      t.integer :price
      t.text :description
      t.integer :capacity
      t.string :address
      t.boolean :is_wifi
      t.boolean :is_food
      t.boolean :is_accessible
      t.string :parking
      t.boolean :active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
