class CreatePaymentLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_line_items do |t|
      t.integer :appointment_id
      t.string :type_key
      t.string :description
      t.decimal :rate
      t.decimal :hours
      t.decimal :amount

      t.timestamps
    end
  end
end
