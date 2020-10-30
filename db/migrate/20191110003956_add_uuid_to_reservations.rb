class AddUuidToReservations < ActiveRecord::Migration[5.2]
  def change
    tables = [
      "reservations"
    ]

    tables.each do |table|
      add_column table, :uuid, :uuid, default: "uuid_generate_v4()", null: false
    end
  end
end
