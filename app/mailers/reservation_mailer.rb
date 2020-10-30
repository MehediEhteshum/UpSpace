class ReservationMailer < ApplicationMailer

  def send_confirmation_to_guest(guest, space)
    @recipient = guest
    @space = space
    mail(to: @recipient.email, bcc: ENV['ADMIN_EMAIL'], subject: "Enjoy Your Event!")
  end

  def send_confirmation_to_host(guest, space)
    @space = space
    @recipient = space.user
    @guest = guest
    mail(to: @recipient.email, subject: "Confirmed Reservation!")
  end

  def send_decline_to_guest(guest, space)
    @recipient = guest
    @space = space
    mail(to: @recipient.email, bcc: ENV['ADMIN_EMAIL'], subject: "Booking Request has been Declined")
  end

  def send_request_to_guest(guest, space)
    @recipient = guest
    @space = space
    mail(to: @recipient.email, subject: "Your Booking Request is Pending")
  end

  def send_request_to_host(guest, space, description)
    @space = space
    @recipient = space.user
    @guest = guest
    @description = description
    mail(to: @recipient.email, bcc: ENV['ADMIN_EMAIL'], subject: "Booking Request Requires Approval")
  end

  def send_card_error_to_guest(guest, space)
    @space = space
    @recipient = guest
    @host = User.find_by_id(space.user_id)
    mail(to: @recipient.email, bcc: ENV['ADMIN_EMAIL'], subject: "Credit Card Declined")
  end

  def send_48_hour_booking_reminder_to_host(reservation)
    @reservation = Reservation.find_by_id(reservation)
    @space = Space.find_by_id(@reservation.space_id)
    @recipient = User.find_by_id(@space.user_id)
    time_format = "%l:%M %p %Z"
    day_format = "%b %d"
    start_time = @reservation.start_date.in_time_zone(current_user.time_zone).localtime.strftime(time_format)
    start_day = @reservation.start_date.in_time_zone(current_user.time_zone).localtime.strftime(day_format)
    end_time = @reservation.end_date.in_time_zone(current_user.time_zone).localtime.strftime(time_format)
    end_day = @reservation.end_date.in_time_zone(current_user.time_zone).localtime.strftime(day_format)
    if @space.listing_type == "Daily" && start_day == end_day
      @from_to = "The booking is on " + start_day + "."
    elsif @space.listing_type == "Daily" && start_day != end_day
      @from_to = "The booking is from " + start_day + " to " + end_day + "."
    elsif @space.listing_type == "Hourly" && start_day == end_day
      @from_to = "The booking is on " + start_day + " from " + start_time + " to " + end_time + "."
    else
      @from_to = "The booking is from " + start_day + " at " + start_time + " to " + end_day + " at " + end_time + "."
    end
    @guest = User.find_by_id(@reservation.user_id)
    mail(to: @recipient.email, bcc: ENV['ADMIN_EMAIL'], subject: "Reminder: Upcoming Booking")
  end

  def send_48_hour_booking_reminder_to_guest(reservation)
    @reservation = Reservation.find_by_id(reservation)
    @space = Space.find_by_id(@reservation.space_id)
    @lister = User.find_by_id(@space.user_id)
    time_format = "%l:%M %p %Z"
    day_format = "%b %d"
    start_time = @reservation.start_date.in_time_zone(current_user.time_zone).localtime.strftime(time_format)
    start_day = @reservation.start_date.in_time_zone(current_user.time_zone).localtime.strftime(day_format)
    end_time = @reservation.end_date.in_time_zone(current_user.time_zone).localtime.strftime(time_format)
    end_day = @reservation.end_date.in_time_zone(current_user.time_zone).localtime.strftime(day_format)
    if @space.listing_type == "Daily" && start_day == end_day
      @from_to = "Your booking is on " + start_day + "."
    elsif @space.listing_type == "Daily" && start_day != end_day
      @from_to = "Your booking is from " + start_day + " to " + end_day + "."
    elsif @space.listing_type == "Hourly" && start_day == end_day
      @from_to = "Your booking is on " + start_day + " from " + start_time + " to " + end_time + "."
    else
      @from_to = "Your booking is from " + start_day + " at " + start_time + " to " + end_day + " at " + end_time + "."
    end
    @recipient = User.find_by_id(@reservation.user_id)
    mail(to: @recipient.email, bcc: ENV['ADMIN_EMAIL'], subject: "Reminder: Upcoming Booking")
  end

  def send_review_reminder_to_host(reservation)
    @reservation = Reservation.find_by_id(reservation)
    @space = Space.find_by_id(@reservation.space_id)
    @recipient = User.find_by_id(@space.user_id)
    @guest = User.find_by_id(@reservation.user_id)
    @subject = "Your Guest " + @guest.fullname + " is Waiting for Your Review"
    mail(to: @recipient.email, bcc: ENV['ADMIN_EMAIL'], subject: @subject)
  end

  def send_review_reminder_to_guest(reservation)
    @reservation = Reservation.find_by_id(reservation)
    @space = Space.find_by_id(@reservation.space_id)
    @lister = User.find_by_id(@space.user_id)
    @recipient = User.find_by_id(@reservation.user_id)
    @subject = "Your Host " + @lister.fullname + " is Waiting for Your Review"
    mail(to: @recipient.email, bcc: ENV['ADMIN_EMAIL'], subject: @subject)
  end

end
