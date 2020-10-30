class AddTimeRequestedToSpaceRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :space_requests, :time_request, :string
  end
end
