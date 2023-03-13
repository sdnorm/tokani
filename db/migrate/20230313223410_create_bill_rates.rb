class CreateBillRates < ActiveRecord::Migration[7.0]
  def change
    create_table :bill_rates do |t|
      t.uuid :account_id, required: true
      t.string :name
      t.decimal :hourly_bill_rate, precision: 8, scale: 2
      t.boolean :is_active, default: true
      t.integer :minimum_time_charged
      t.integer :round_time
      t.integer :round_increment
      t.decimal :after_hours_overage, precision: 8, scale: 2
      t.integer :after_hours_start_seconds
      t.integer :after_hours_end_seconds
      t.decimal :rush_overage, precision: 8, scale: 2
      t.integer :rush_overage_trigger
      t.decimal :cancel_rate, precision: 8, scale: 2
      t.integer :cancel_rate_trigger
      t.boolean :default_rate, default: false
      t.boolean :in_person, default: false
      t.boolean :phone, default: false
      t.boolean :video, default: false

      t.timestamps
    end
  end
end
