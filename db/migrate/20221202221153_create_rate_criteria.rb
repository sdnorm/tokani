class CreateRateCriteria < ActiveRecord::Migration[7.0]
  def change
    create_table :rate_criteria do |t|
      t.references :account
      t.integer :type_key, null: false
      t.string :name
      t.integer :sort_order, null: false
      t.timestamps
    end
  end
end
