class AddCancelTypeToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :cancel_type, :integer
  end
end
