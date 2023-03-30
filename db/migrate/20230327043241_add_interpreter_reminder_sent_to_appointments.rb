class AddInterpreterReminderSentToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :interpreter_reminder_sent, :boolean, default: false
  end
end
