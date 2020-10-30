class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.boolean :enable_sms, default: true
      t.boolean :enable_email, default: true
      t.references :user, foreign_key: true

      t.timestamps
    end

    # Look through existing users and set options to TRUE
    User.find_each do |user|
      Setting.create(user: user, enable_email: true, enable_sms: true)
    end

  end
end
