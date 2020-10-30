class ExtractSpacePrices < ActiveRecord::Migration[5.2]
  def change
    Space.find_each do |space|
      listing_type = space.listing_type == 'Hourly' ? 1 : 2
      Price.create(price: space.price, price_type_id: listing_type, space_id: space.id, active: true)
    end
  end
end
