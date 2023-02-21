class CreateAgencyDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :agency_details do |t|
      t.string :url
      t.string :phone_number
      t.string :primary_contact_first_name
      t.string :primary_contact_last_name
      t.string :primary_contact_title
      t.string :primary_contact_email
      t.string :primary_contact_phone_number
      t.string :secondary_contact_first_name
      t.string :secondary_contact_last_name
      t.string :secondary_contact_title
      t.string :secondary_contact_email
      t.string :secondary_contact_phone_number

      t.timestamps
    end
  end
end
