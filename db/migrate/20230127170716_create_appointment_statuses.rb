class CreateAppointmentStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :appointment_statuses do |t|
      t.integer :name
      t.uuid :user, null: false, foreign_key: true
      t.uuid :appointment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
