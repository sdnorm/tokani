class CreatePayBillRates < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_bill_rates do |t|
      t.uuid :account_id
      t.string :name
      t.boolean :is_default
      t.date :effective_date
      t.decimal :bill_rate
      t.decimal :pay_rate
      t.decimal :after_hours_bill_rate
      t.decimal :after_hours_pay_rate
      t.decimal :rush_bill_rate
      t.decimal :rush_pay_rate
      t.decimal :discount_bill_rate
      t.decimal :discount_pay_rate
      t.decimal :cancel_level_1_bill_rate
      t.decimal :cancel_level_1_pay_rate
      t.decimal :cancel_level_2_bill_rate
      t.decimal :cancel_level_2_pay_rate
      t.decimal :mileage_rate
      t.decimal :travel_time_rate
      t.boolean :in_person
      t.boolean :phone
      t.boolean :video
      t.jsonb :interpreter_types
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
