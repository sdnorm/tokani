class CreatePayBillRateInterpreterTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_bill_rate_interpreter_types do |t|
      t.integer :pay_bill_rate_id
      t.integer :interpreter_type

      t.timestamps
    end
  end
end
