class AdminController < ApplicationController
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!
  before_action :verify_admin

  def index
    @chart_user_signups = User.all.group_by_month(:created_at).count.transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }
    @chart_active_users = User.all.group_by_month(:current_sign_in_at).count.transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }

    @chart_spaces_created = Space.all.group_by_month(:created_at).count.transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }

    @chart_booking_value_accepted = Reservation.where('status = ?', 1).group_by_month(:start_date).sum(:total).transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }
    @chart_booking_value_pending = Reservation.where('status = ?', 0).group_by_month(:start_date).sum(:total).transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }
    @chart_booking_value_declined = Reservation.where('status = ?', 2).group_by_month(:start_date).sum(:total).transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }
    @chart_booking_value_cancelled = Reservation.where('status = ?', 3).group_by_month(:start_date).sum(:total).transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }
    @chart_booking_value_refunded = Reservation.where('status = ?', 3).group_by_month(:start_date).sum(:total).transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }

    @chart_bookings_accepted = Reservation.where('status = ?', 1).group_by_month(:start_date).count.transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }
    @chart_bookings_pending = Reservation.where('status = ?', 0).group_by_month(:start_date).count.transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }
    @chart_bookings_declined = Reservation.where('status = ?', 2).group_by_month(:start_date).count.transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }
    @chart_bookings_cancelled = Reservation.where('status = ?', 3).group_by_month(:start_date).count.transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }
    @chart_bookings_refunded = Reservation.where('status = ?', 3).group_by_month(:start_date).count.transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }

    @total_users = User.all.count
    @active_users = User.where(current_sign_in_at: 30.days.ago..DateTime::Infinity.new).count
    @total_spaces = Space.all.count
    @published_spaces = Space.where(active: true).count
    @total_booking_requests = Reservation.all.count
    @accepted_booking_requests = Reservation.where('status = ?', 1).count
    @accepted_booking_value = Reservation.where('status = ?', 1).sum(:total)

    @upcoming_reservations = Reservation.where('start_date > ?', DateTime.now)
  end

  def send_test_user_welcome_email
    UserMailer.send_welcome_to_user(current_user).deliver_later
    flash[:success] = "Email Sent!"
    redirect_to request.referrer
  end

  def send_test_lister_welcome_email
    SpaceMailer.send_lister_welcome(current_user.spaces.first.id).deliver_later
    flash[:success] = "Email Sent!"
    redirect_to request.referrer
  end

  def send_test_user_confirmation_email
    current_user.send_confirmation_instructions
    flash[:success] = "Email Sent!"
    redirect_to request.referrer
  end

  def send_test_lister_review_request_email
    ReservationMailer.send_review_reminder_to_host(current_user.reservations.first.id).deliver_later
    flash[:success] = "Email Sent!"
    redirect_to request.referrer
  end

  def send_test_renter_review_request_email
    ReservationMailer.send_review_reminder_to_guest(current_user.reservations.first.id).deliver_later
    flash[:success] = "Email Sent!"
    redirect_to request.referrer
  end

  def send_test_lister_booking_reminder_email
    ReservationMailer.send_48_hour_booking_reminder_to_host(current_user.reservations.first.id).deliver_later
    flash[:success] = "Email Sent!"
    redirect_to request.referrer
  end

  def send_test_renter_booking_reminder_email
    ReservationMailer.send_48_hour_booking_reminder_to_guest(current_user.reservations.first.id).deliver_later
    flash[:success] = "Email Sent!"
    redirect_to request.referrer
  end

  def admin_users
    @users = User.all.order(id: :desc)
  end

  def admin_spaces
    @spaces = Space.all.order(id: :desc)
  end

  def admin_reservations
    @reservations = Reservation.all.order(id: :desc)
  end

  def admin_email
    @user_welcome_recipient = current_user.email

    @lister_review_recipient = User.find_by_id(Space.find_by_id(current_user.reservations.first.space_id).user_id).email
    @renter_review_recipient = User.find_by_id(current_user.reservations.first.user_id).email

    @lister_booking_reminder_recipient = User.find_by_id(Space.find_by_id(current_user.reservations.first.space_id).user_id).email
    @renter_booking_reminder_recipient = User.find_by_id(current_user.reservations.first.user_id).email
  end

  def verify_admin
    if !current_user.try(:admin?)
      redirect_to root_path
    end
  end

end
