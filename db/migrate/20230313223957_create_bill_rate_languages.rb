class CreateBillRateLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :bill_rate_languages do |t|
      t.integer :bill_rate_id
      t.integer :language_id

      t.timestamps
    end
  end
end
