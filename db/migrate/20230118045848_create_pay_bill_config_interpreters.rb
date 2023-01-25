class CreatePayBillConfigInterpreters < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_bill_config_interpreters do |t|
      t.integer :pay_bill_config_id
      t.uuid :user_id

      t.timestamps
    end
  end
end
