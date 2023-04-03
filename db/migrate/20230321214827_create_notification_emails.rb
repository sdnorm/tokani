class CreateNotificationEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :notification_emails do |t|
      t.uuid :account_id
      t.string :email1
      t.string :email2
      t.boolean :appointment_created, default: true
      t.boolean :appointment_edited, default: true
      t.boolean :appointment_declined, default: true
      t.boolean :appointment_cancelled, default: true

      t.timestamps
    end
  end
end
