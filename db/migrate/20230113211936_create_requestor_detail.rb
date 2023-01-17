class CreateRequestorDetail < ActiveRecord::Migration[7.0]
  def change
    create_table :requestor_details do |t|
      t.boolean :allow_offsite
      t.boolean :allow_view_docs
      t.boolean :allow_view_checklist
      t.string :primary_phone
      t.string :work_phone
      t.uuid :customer_id
      t.uuid :site_id
      t.uuid :department_id
      t.uuid :requestor_id, null: false, foreign_key: {to_table: :users}, index: true

      t.timestamps
    end

  end
end
