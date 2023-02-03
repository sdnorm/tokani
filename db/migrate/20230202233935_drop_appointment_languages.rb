class DropAppointmentLanguages < ActiveRecord::Migration[7.0]
  def change
    drop_table :appointment_languages
  end
end
