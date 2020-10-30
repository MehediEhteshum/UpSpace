class AddCreatedAtIndexToReservations < ActiveRecord::Migration[5.2]
  def change
    add_index :reservations, :created_at
  end
end
