class CreateSites < ActiveRecord::Migration[7.0]
  def change
    create_table :sites do |t|
      t.string :name
      t.string :contact_name
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.boolean :active
      t.bigint :backport_id
      t.text :notes
      t.string :contact_phone

      t.timestamps
    end
    add_index :sites, :backport_id
  end
end
