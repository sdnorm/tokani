class CreateCustomerCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_categories do |t|
      t.string :display_value
      t.string :appointment_prefix
      t.string :telephone_prefix
      t.string :video_prefix
      t.bigint :backport_id
      t.bigint :sort_order
      t.boolean :is_active

      t.timestamps
    end
    add_index :customer_categories, :display_value
    add_index :customer_categories, :backport_id
  end
end
