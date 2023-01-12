class CreatePayBillRateDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_bill_rate_departments do |t|
      t.integer :pay_bill_rate_id
      t.uuid :department_id

      t.timestamps
    end
  end
end
