class CreatePayRateLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_rate_languages do |t|
      t.integer :pay_rate_id
      t.integer :language_id

      t.timestamps
    end
  end
end
