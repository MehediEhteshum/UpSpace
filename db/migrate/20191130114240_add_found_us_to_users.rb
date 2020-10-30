class AddFoundUsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :found_us, :string
  end
end
