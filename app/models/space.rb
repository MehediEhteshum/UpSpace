class Space < ApplicationRecord

  attr_accessor :prices_attribute

  enum instant: {Request: 0, Instant: 1}

  belongs_to :user
  has_many :photos
  has_many :prices
  accepts_nested_attributes_for :prices
  has_many :reservations
  has_many :guest_reviews
  has_many :calendars
  has_many :favourites

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :listing_category, presence: true
  validates :capacity, presence: true
  validates :parking, presence: true

  def cover_photo(size)
    if self.photos.length > 0
      self.photos.order(:sort).first.image.url(size)
    else
      "blank.jpg"
    end
  end

  def average_rating
    guest_reviews.count == 0 ? 5 : guest_reviews.average(:star).round(2).to_i
  end

  def has_active_hourly_price
    Price.where(
      "space_id = ? AND price_type_id = ? AND active = ?",
      self.id, 1, true
    ).any?
  end

  def has_active_daily_price
    Price.where(
      "space_id = ? AND price_type_id = ? AND active = ?",
      self.id, 2, true
    ).any?
  end

  def has_active_price
    Price.where(
      "space_id = ? AND active = ?",
      self.id, true
    ).any?
  end

end
