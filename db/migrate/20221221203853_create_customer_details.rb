class CreateCustomerDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_details do |t|
      t.string :contact_name
      t.string :email
      t.text :notes
      t.string :phone
      t.string :fax
      t.boolean :appointments_in_person, default: true
      t.boolean :appointments_video, default: true
      t.boolean :appointments_phone, default: true
      t.uuid :customer_id, null: false, foreign_key: {to_table: :accounts}, index: true

      t.timestamps
    end
  end
end
