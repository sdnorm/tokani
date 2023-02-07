class CreateReportCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :report_customers do |t|
      t.integer :report_id
      t.uuid :account_id

      t.timestamps
    end
  end
end
