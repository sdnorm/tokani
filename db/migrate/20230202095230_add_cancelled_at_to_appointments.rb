class AddCancelledAtToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :cancelled_at, :datetime
  end
end
