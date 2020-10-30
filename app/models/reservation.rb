class Reservation < ApplicationRecord

  default_scope -> { order("created_at ASC") }

  enum status: {Checkout: -1, Waiting: 0, Approved: 1, Declined: 2, Cancelled: 3, Refunded: 4}

  belongs_to :user
  belongs_to :space

  scope :current_week_revenue, -> (user) {
    joins(:space)
    .where("spaces.user_id = ? AND reservations.updated_at >= ? AND reservations.status = ?", user.id, 1.week.ago, 1)
    .order(updated_at: :asc)
  }

  def helpers
    ActionController::Base.helpers
  end

  def receipt
    user = User.find(self.user_id)
    host = User.find(Space.find(self.space_id).user_id)
    space = Space.find(self.space_id)
    amount = helpers.number_to_currency(self.total)
    duration = self.term
    period = self.price_type == "daily" ? "day" : "hour"
    date = self.start_date.in_time_zone(user.time_zone).strftime("%h %d, %G %I:%M%p").to_s + " - " + self.end_date.in_time_zone(user.time_zone).strftime("%h %d, %G %I:%M%p").to_s

    Receipts::Receipt.new(
      id: id,
      subheading: "REFERENCE #%{id}",
      message: "Thanks for booking with upSpace! Please keep this receipt for your records. For questions, contact us anytime at <color rgb='009874'><link href='mailto:hello@upspace.ca?subject=Reservation ##{id}'><b>hello@upspace.ca</b></link></color>.",
      company: {
        name: "upSpace Inc.",
        address: "515 Legget Drive Suite 800\nOttawa, ON, K2K 3G4",
        email: "hello@upspace.ca",
        logo: Rails.root.join("app/assets/images/upspace.png")
      },
      line_items: [
        ["BOOKING DETAILS", ""],
        ["Billed To",       "#{user.fullname}"],
        ["Email",           "#{user.email}"],
        ["Space",           "#{space.title}"],
        ["Date",            date],
        ["Duration",        "#{duration} #{period}(s)"],
        ["CHARGE DETAILS",  ""],
        # ["Date Charged",    updated_at.strftime("%h %d, %G").to_s],

        ["Amount",          amount]
      ],
      font: {
        bold: Rails.root.join('app/assets/fonts/Nunito-Bold.ttf'),
        normal: Rails.root.join('app/assets/fonts/Nunito-Regular.ttf'),
      }
    )
  end

  def send_48_hour_reminder_to_guest(reservation)
    ReservationMailer.send_48_hour_booking_reminder_to_guest(reservation.id).deliver_later if reservation.user.setting.enable_email && reservation.guest_48_hour_reminder_sent_at.nil?
    reservation.guest_48_hour_reminder_sent_at = Time.now()
    reservation.save
  end

  def send_48_hour_reminder_to_host(reservation)
    ReservationMailer.send_48_hour_booking_reminder_to_host(reservation.id).deliver_later if reservation.space.user.setting.enable_email && reservation.host_48_hour_reminder_sent_at.nil?
    reservation.host_48_hour_reminder_sent_at = Time.now()
    reservation.save
  end

  def has_guest_review
    Review.where(
      "reservation_id = ? AND type = ?",
      self.id, "GuestReview"
    ).any?
  end

  def has_host_review
    Review.where(
      "reservation_id = ? AND type = ?",
      self.id, "HostReview"
    ).any?
  end


  private

    def create_notification
      type = self.space.Instant? ? "New Booking" : "New Request"
      guest = User.find(self.user_id)

      Notification.create(content: "#{type} from #{guest.fullname}", user_id: self.space.user_id)
    end

end
