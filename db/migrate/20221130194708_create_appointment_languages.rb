class CreateAppointmentLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :appointment_languages do |t|
      t.references :appointment, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end
  end
end
