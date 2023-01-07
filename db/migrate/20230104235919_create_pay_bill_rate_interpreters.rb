class CreatePayBillRateInterpreters < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_bill_rate_interpreters do |t|
      t.integer :pay_bill_rate_id
      t.uuid :user_id

      t.timestamps
    end
  end
end
