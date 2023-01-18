class CreatePayBillConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_bill_configs do |t|
      t.uuid :account_id
      t.string :name
      t.integer :minimum_minutes_billed
      t.integer :minimum_minutes_paid
      t.integer :billing_increment
      t.integer :trigger_for_billing_increment
      t.integer :trigger_for_rush_rate
      t.integer :trigger_for_discount_rate
      t.integer :trigger_for_cancel_level1
      t.integer :trigger_for_cancel_level2
      t.integer :trigger_for_travel_time
      t.integer :trigger_for_mileage
      t.integer :maximum_mileage
      t.integer :maximum_travel_time
      t.integer :fixed_roundtrip_mileage
      t.integer :afterhours_availability_start_seconds1
      t.integer :afterhours_availability_end_seconds1
      t.integer :afterhours_availability_start_seconds2
      t.integer :afterhours_availability_end_seconds2
      t.integer :weekend_availability_start_seconds1
      t.integer :weekend_availability_end_seconds1
      t.integer :weekend_availability_start_seconds2
      t.integer :weekend_availability_end_seconds2
      t.boolean :is_minutes_billed_appointment_duration, default: false
      t.integer :minimum_minutes_billed_cancelled_level_1
      t.integer :minimum_minutes_paid_cancelled_level_1
      t.integer :minimum_minutes_billed_cancelled_level_2
      t.integer :minimum_minutes_paid_cancelled_level_2
      t.boolean :is_minutes_billed_cancelled_appointment_duration, default: false
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
