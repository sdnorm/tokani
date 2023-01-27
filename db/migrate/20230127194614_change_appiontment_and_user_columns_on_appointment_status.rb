class ChangeAppiontmentAndUserColumnsOnAppointmentStatus < ActiveRecord::Migration[7.0]
  def change
    rename_column :appointment_statuses, :user, :user_id
    rename_column :appointment_statuses, :appointment, :appointment_id
  end
end
