class CreatePayBillRateSites < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_bill_rate_sites do |t|
      t.integer :pay_bill_rate_id
      t.uuid :site_id

      t.timestamps
    end
  end
end
