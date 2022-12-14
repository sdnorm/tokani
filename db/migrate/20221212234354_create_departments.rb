class CreateDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :departments, id: :uuid do |t|
      t.string :name
      t.text :location
      t.string :accounting_unit_code
      t.text :accounting_unit_desc
      t.boolean :is_active, default: true, null: false
      t.belongs_to :site, null: false, foreign_key: true, type: :uuid
      t.integer :backport_id

      t.timestamps
    end
  end
end
