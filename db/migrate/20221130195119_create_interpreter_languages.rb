class CreateInterpreterLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :interpreter_languages do |t|
      t.references :language, null: false, foreign_key: true
      t.references :interpreter, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
