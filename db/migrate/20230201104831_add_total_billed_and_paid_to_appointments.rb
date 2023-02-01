class AddTotalBilledAndPaidToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :total_billed, :decimal
    add_column :appointments, :total_paid, :decimal
  end
end
