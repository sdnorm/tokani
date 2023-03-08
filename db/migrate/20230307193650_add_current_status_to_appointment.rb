class AddCurrentStatusToAppointment < ActiveRecord::Migration[7.0]
  def change
    # remove_column :appointments, :current_status
    add_column :appointments, :current_status, :string
  end
end
