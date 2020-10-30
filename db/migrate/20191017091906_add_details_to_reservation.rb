class AddDetailsToReservation < ActiveRecord::Migration[5.2]
  def change
    change_column :reservations, :price, :decimal, precision: 8, scale: 2
    change_column :reservations, :total, :decimal, precision: 8, scale: 2
    add_column :reservations, :price_type, :string
    add_column :reservations, :term, :decimal, precision: 8, scale: 2
    add_column :reservations, :charge_id, :string
    add_column :reservations, :authorized_at, :datetime
    add_column :reservations, :captured_at, :datetime
    add_column :reservations, :source_id, :string
    add_column :reservations, :description, :text
  end
end
