class Add48HourRemindersToReservation < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :guest_48_hour_reminder_sent_at, :datetime
    add_column :reservations, :host_48_hour_reminder_sent_at, :datetime
  end
end
