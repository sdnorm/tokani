class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.uuid :account_id
      t.integer :report_type
      t.date :date_begin
      t.date :date_end
      t.boolean :in_person
      t.boolean :phone
      t.boolean :video
      t.string :interpreter_type
      t.integer :customer_category_id
      t.uuid :site_id
      t.uuid :department_id
      t.integer :language_id
      t.string :fields_to_show

      t.timestamps
    end
  end
end
