class CreateProcessBatchAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :process_batch_appointments do |t|
      t.integer :process_batch_id
      t.integer :appointment_id

      t.timestamps
    end
  end
end
