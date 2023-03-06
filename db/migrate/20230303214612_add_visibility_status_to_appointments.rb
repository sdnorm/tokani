class AddVisibilityStatusToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :visibility_status, :integer
  end
end
