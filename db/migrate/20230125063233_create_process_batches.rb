class CreateProcessBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :process_batches do |t|
      t.uuid :account_id
      t.integer :process_id
      t.integer :batch_type
      t.decimal :total
      t.boolean :is_processed, default: false

      t.timestamps
    end
  end
end
