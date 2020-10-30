class AddDefaultBooleanToOtherFields < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :phone_verified, :boolean, null: false, default: false
    change_column :settings, :enable_sms, :boolean, null: false, default: false
    change_column :settings, :enable_email, :boolean, null: false, default: true
    change_column :spaces, :active, :boolean, null: false, default: false
  end
end
