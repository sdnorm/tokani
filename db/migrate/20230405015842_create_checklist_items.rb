class CreateChecklistItems < ActiveRecord::Migration[7.0]
  def change
    create_table :checklist_types do |t|
      t.belongs_to :account, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.integer :format
      t.boolean :is_active, default: true, null: false
      t.boolean :requires_expiration
      t.boolean :requires_upload

      t.timestamps
    end

    create_table :checklist_items do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.belongs_to :checklist_type, null: false, foreign_key: true
      t.boolean :bool_val
      t.string :text_val
      t.date :start_date
      t.date :exp_date

      t.timestamps
    end
  end
end
