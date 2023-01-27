class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers, id: :uuid do |t|
      t.string :last_name
      t.string :first_name
      t.string :email
      t.string :primary_phone
      t.boolean :allow_text
      t.boolean :allow_email

      t.belongs_to :account, foreign_key: true, type: :uuid
      t.belongs_to :site, foreign_key: true, type: :uuid
      t.belongs_to :department, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
