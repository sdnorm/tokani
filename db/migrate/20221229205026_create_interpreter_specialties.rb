class CreateInterpreterSpecialties < ActiveRecord::Migration[7.0]
  def change
    create_table :interpreter_specialties do |t|
      t.references :specialty, null: false, foreign_key: true
      t.uuid :interpreter_id, null: false, foreign_key: {to_table: :users}, index: true

      t.timestamps
    end
  end
end
