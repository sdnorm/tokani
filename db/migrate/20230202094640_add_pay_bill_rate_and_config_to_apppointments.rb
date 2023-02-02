class AddPayBillRateAndConfigToApppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :pay_bill_config_id, :integer
    add_column :appointments, :pay_bill_rate_id, :integer
  end
end
