class CreatePayRateInterpreters < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_rate_interpreters do |t|
      t.integer :pay_rate_id
      t.uuid :interpreter_id

      t.timestamps
    end
  end
end
