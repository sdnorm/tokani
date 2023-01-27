class AddCurrentBooleanToAppointmentStatus < ActiveRecord::Migration[7.0]
  def change
    add_column :appointment_statuses, :current, :boolean
  end
end
