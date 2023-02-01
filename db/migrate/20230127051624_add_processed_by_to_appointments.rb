class AddProcessedByToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :processed_by_customer, :boolean, default: false
    add_column :appointments, :processed_by_interpreter, :boolean, default: false
  end
end
