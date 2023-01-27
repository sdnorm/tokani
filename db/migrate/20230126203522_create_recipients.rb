class CreateRecipients < ActiveRecord::Migration[7.0]
  def change
    create_table :recipients do |t|
      t.string :last_name
      t.string :first_name
      t.string :email
      t.string :srn
      t.string :primary_phone
      t.string :mobile_phone
      t.boolean :allow_text
      t.boolean :allow_email
      t.references :customer, null: false, foreign_key: {to_table: :accounts}, index: true, type: :uuid

      t.timestamps
    end
  end
end
