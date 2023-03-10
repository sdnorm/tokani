class CreateNotificationSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :notification_settings do |t|
      t.uuid :user_id
      t.integer :sms, default: 2
      t.boolean :appointment_offered, default: true
      t.boolean :appointment_scheduled, default: true
      t.boolean :appointment_cancelled, default: true

      t.timestamps
    end
  end
end
