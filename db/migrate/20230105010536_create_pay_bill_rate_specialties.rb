class CreatePayBillRateSpecialties < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_bill_rate_specialties do |t|
      t.integer :pay_bill_rate_id
      t.integer :specialty_id

      t.timestamps
    end
  end
end
