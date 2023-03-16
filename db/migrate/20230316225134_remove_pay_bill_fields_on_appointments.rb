class RemovePayBillFieldsOnAppointments < ActiveRecord::Migration[7.0]
  def change
    remove_column :appointments, :pay_bill_config_id
    remove_column :appointments, :pay_bill_rate_id
  end
end
