class CreateSpaceRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :space_requests do |t|
      t.integer :user_id
      t.datetime :date_request
      t.text :description
      t.string :city

      t.timestamps
    end
  end
end
