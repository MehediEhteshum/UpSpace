class CreateCalendars < ActiveRecord::Migration[5.1]
  def change
    create_table :calendars do |t|
      t.date :day
      t.integer :price
      t.integer :status
      t.references :space, foreign_key: true

      t.timestamps
    end
  end
end
