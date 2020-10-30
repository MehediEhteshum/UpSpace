
  desc 'Sends reminder emails for reservations less than 48 hours away'
  task send_48_hour_reminders: :environment do
    reservations_for_48_hour_reminder = Reservation.where(
      "status = ? AND start_date BETWEEN ? AND ?",
      1, Time.now(), Time.now() + 2.days
    )
    reservations_for_48_hour_reminder.each do |reservation|
      if reservation.user.setting.enable_email && reservation.guest_48_hour_reminder_sent_at.nil?
        ReservationMailer.send_48_hour_booking_reminder_to_guest(reservation.id).deliver_now
        reservation.guest_48_hour_reminder_sent_at = Time.now()
        reservation.save
      end
      if reservation.space.user.setting.enable_email && reservation.host_48_hour_reminder_sent_at.nil?
        ReservationMailer.send_48_hour_booking_reminder_to_host(reservation.id).deliver_now
        reservation.host_48_hour_reminder_sent_at = Time.now()
        reservation.save
      end
    end
  end

  desc 'Sends review reminder emails for reservations completed the prior day'
  task send_review_reminders: :environment do
    reservations_for_review_reminder = Reservation.where(
      "status = ? AND DATE(end_date) = ?",
      1, Date.today - 1.day
    )
    reservations_for_review_reminder.each do |reservation|
      if reservation.user.setting.enable_email && !reservation.has_guest_review
        ReservationMailer.send_review_reminder_to_guest(reservation.id).deliver_now
      end
      if reservation.space.user.setting.enable_email && !reservation.has_host_review
        ReservationMailer.send_review_reminder_to_host(reservation.id).deliver_now
      end
    end
  end
