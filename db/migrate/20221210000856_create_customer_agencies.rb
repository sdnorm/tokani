class CreateCustomerAgencies < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_agencies do |t|
      t.uuid :agency_id, null: false, foreign_key: {to_table: :accounts}, index: true
      t.uuid :customer_id, null: false, foreign_key: {to_table: :accounts}, index: true

      t.timestamps
    end
  end
end
