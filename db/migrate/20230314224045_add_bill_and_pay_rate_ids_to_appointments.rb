class AddBillAndPayRateIdsToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :bill_rate_id, :integer
    add_column :appointments, :pay_rate_id, :integer
  end
end
