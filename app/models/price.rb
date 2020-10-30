class Price < ApplicationRecord
  belongs_to :space
  has_one :price_type
  enum price_type_id: [:free, :hourly, :daily, :weekly, :monthly]
end
