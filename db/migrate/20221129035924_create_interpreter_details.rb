class CreateInterpreterDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :interpreter_details do |t|
      t.integer :interpreter_type
      t.integer :gender
      t.string :primary_phone

      t.timestamps
    end
  end
end
