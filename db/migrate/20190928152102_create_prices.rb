class CreatePrices < ActiveRecord::Migration[5.2]
  def change
    create_table :price_types do |p|
      p.string :name
      p.timestamps
    end

    types = [
      "Free",
      "Hourly",
      "Daily",
      "Weekly",
      "Monthly"
    ]

    types.each do |type|
      PriceType.create(name: type)
    end

    create_table :prices do |t|
      t.decimal :price, precision: 8, scale: 2
      t.integer :price_type_id
      t.references :space, null: false, foreign_key: true
      t.boolean :active, null: false, default: true
      t.timestamps
    end
  end
end
