class ChangeAppointmentReferenceOnAppointmentStatus < ActiveRecord::Migration[7.0]
  def change
    remove_column :appointment_statuses, :appointment_id, :uuid
    add_reference :appointment_statuses, :appointment, foreign_key: true
  end
end
