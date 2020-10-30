class ChangeDataTypeForSpaceRequests < ActiveRecord::Migration[5.2]
  def change
    change_column :space_requests, :date_request, :string
  end
end
