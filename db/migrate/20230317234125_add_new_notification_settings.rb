class AddNewNotificationSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :notification_settings, :appointment_created, :boolean, default: true
    add_column :notification_settings, :appointment_declined, :boolean, default: true
    add_column :notification_settings, :interpreter_cancelled, :boolean, default: true
  end
end
