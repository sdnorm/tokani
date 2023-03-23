class AddAssignedInterpreterToAppointment < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :assigned_interpreter, :uuid
  end
end
