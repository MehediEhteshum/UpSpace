class CreateAdditionalSpacePrices < ActiveRecord::Migration[5.2]
  def change
    Price.find_each do |price|
      price_type_id = price.price_type_id == 1 ? 2 : 1
      space_id = price.space_id
      Price.create(price_type_id: price_type_id, space_id: space_id, active: false)
    end
  end
end
