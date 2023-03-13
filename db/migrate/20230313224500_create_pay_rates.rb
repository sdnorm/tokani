class CreatePayRates < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_rates do |t|
      t.uuid :account_id, required: true
      t.string :name
      t.decimal :hourly_pay_rate, precision: 8, scale: 2
      t.boolean :is_active, default: true
      t.integer :minimum_time_charged
      t.decimal :after_hours_overage, precision: 8, scale: 2
      t.decimal :rush_overage, precision: 8, scale: 2
      t.decimal :cancel_rate, precision: 8, scale: 2
      t.boolean :default_rate, default: false
      t.boolean :in_person, default: false
      t.boolean :phone, default: false
      t.boolean :video, default: false

      t.timestamps
    end
  end
end
