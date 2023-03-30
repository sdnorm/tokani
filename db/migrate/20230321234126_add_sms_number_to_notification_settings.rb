class AddSmsNumberToNotificationSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :notification_settings, :sms_number, :string
  end
end
