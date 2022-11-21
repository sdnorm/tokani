class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.string :ref_number
      t.datetime :start_time
      t.datetime :finish_time
      t.integer :duration
      t.integer :modality
      t.integer :sub_type
      t.integer :gender_req
      t.text :admin_notes
      t.text :notes
      t.text :details
      t.boolean :status
      t.integer :interpreter_type
      t.text :billing_notes
      t.integer :canceled_by
      t.integer :cancel_reason_code
      t.integer :lock_version
      t.string :time_zone
      t.datetime :confirmation_date
      t.string :confirmation_phone
      t.text :confirmation_notes
      t.boolean :home_health_appointment

      t.timestamps
    end
  end
end
