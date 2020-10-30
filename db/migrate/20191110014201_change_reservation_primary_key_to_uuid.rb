class ChangeReservationPrimaryKeyToUuid < ActiveRecord::Migration[5.2]
  def change
    tables = [
      "reservations"
    ]

    tables.each do |table|
      remove_column table, :id
      rename_column table, :uuid, :id
      execute "ALTER TABLE #{table} ADD PRIMARY KEY (id);"
    end
  end
end
