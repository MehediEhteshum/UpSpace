class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :masqueradable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[facebook]

  validates :fullname, presence: true, length: {maximum: 50}
  validates :terms_agreement, acceptance: true

  enum user_type: { Lister: 0, Renter: 1, ListerRenter: 2 }

  has_one :avatar
  has_many :spaces
  has_many :reservations
  has_many :guest_reviews, class_name: "GuestReview", foreign_key: "guest_id"
  has_many :host_reviews, class_name: "HostReview", foreign_key: "host_id"
  has_many :notifications
  has_many :favourites

  has_one :setting
  after_create :add_setting
  after_create :send_admin_mail

  belongs_to :referred_by, class_name: "User", optional: true
  has_many :referred_users, class_name: "User", foreign_key: :referred_by_id

  before_validation :set_referral_code
  validates :referral_code, uniqueness: true

  attribute :nickname,  :captcha  => true

  def add_setting
    Setting.create(user: self, enable_sms: true, enable_email: true)
  end

  def set_referral_code
    if self.referral_code.nil?
      loop do
        self.referral_code = SecureRandom.hex(6)
        break unless self.class.exists?(referral_code: referral_code)
      end
    end
  end

  def send_admin_mail
    UserMailer.send_user_notification_to_admin(self).deliver_later
  end

  def after_confirmation
    UserMailer.send_welcome_to_user(self).deliver_later
  end

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first

    if user
      return user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.fullname = auth.info.name
        user.image = auth.info.image
        user.uid = auth.uid
        user.provider = auth.provider

        # If you are using confirmable and the provider(s) you use validate emails,
        # uncomment the line below to skip the confirmation emails.
        user.skip_confirmation!
      end
    end
  end

  def generate_pin
    self.pin = SecureRandom.hex(2)
    self.phone_verified = false
    save
  end

  def send_pin

    @client = Twilio::REST::Client.new(Rails.application.secrets.twilio_sid, Rails.application.secrets.twilio_token)

    message = @client.messages
                     .create(
                        body: "Welcome to upSpace! Your PIN is #{self.pin}",
                        from: Rails.application.secrets[:twilio][:number],
                        to: self.phone_number
                      )

    # puts message.sid
    # @client = Twilio::REST::Client.new Rails.application.secrets.twilio_sid, Rails.application.secrets.twilio_token
    # @client.messages.create(
    #   from: '+16134820355',
    #   to: self.phone_number,
    #   body: "Welcome to upSpace! Your PIN is #{self.pin}"
    # )

  end

  def verify_pin(entered_pin)
    update(phone_verified: true) if self.pin == entered_pin
  end

  def is_active_host
    !self.merchant_id.blank?
  end

  def likes?(space)
    space.favourites.where(user_id: id).any?
  end

end
