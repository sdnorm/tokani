class AddAccountRelationshipToAppointment < ActiveRecord::Migration[7.0]
  def change
    add_reference :appointments, :agency, foreign_key: {to_table: :accounts}, index: true
    add_reference :appointments, :customer, foreign_key: {to_table: :accounts}, index: true
  end
end
