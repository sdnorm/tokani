class CreatePayBillRateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_bill_rate_customers do |t|
      t.integer :pay_bill_rate_id
      t.uuid :account_id

      t.timestamps
    end
  end
end
