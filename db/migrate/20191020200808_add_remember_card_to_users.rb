class AddRememberCardToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :remember_card, :boolean, null: false, default: false
  end
end
