class AddMoreNotificationSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :notification_settings, :appointment_edited, :boolean, default: true
    add_column :notification_settings, :appointment_covered, :boolean, default: true
    add_column :notification_settings, :appointment_reminder, :boolean, default: true
  end
end
