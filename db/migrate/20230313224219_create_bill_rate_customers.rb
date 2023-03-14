class CreateBillRateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :bill_rate_customers do |t|
      t.integer :bill_rate_id
      t.uuid :customer_id

      t.timestamps
    end
  end
end
