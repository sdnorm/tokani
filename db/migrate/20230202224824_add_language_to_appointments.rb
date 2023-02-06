class AddLanguageToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_reference :appointments, :language, null: false, foreign_key: true
  end
end
