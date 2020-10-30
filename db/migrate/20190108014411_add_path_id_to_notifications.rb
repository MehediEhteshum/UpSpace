class AddPathIdToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :path_id, :int
  end
end
