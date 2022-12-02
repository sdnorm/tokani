class AddFieldsToInterpreterDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :interpreter_details, :ssn, :string
    add_column :interpreter_details, :dob, :date
    add_column :interpreter_details, :address, :string
    add_column :interpreter_details, :city, :string
    add_column :interpreter_details, :state, :string
    add_column :interpreter_details, :zip, :string
    add_column :interpreter_details, :fname, :string
    add_column :interpreter_details, :lname, :string
    add_column :interpreter_details, :start_date, :date
    add_column :interpreter_details, :drivers_license, :string
    add_column :interpreter_details, :emergency_contact_name, :string
    add_column :interpreter_details, :emergency_contact_phone, :string
  end
end
