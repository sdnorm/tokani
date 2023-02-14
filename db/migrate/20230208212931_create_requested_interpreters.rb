class CreateRequestedInterpreters < ActiveRecord::Migration[7.0]
  def change
    create_table :requested_interpreters do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.belongs_to :appointment, null: false, foreign_key: true
      t.boolean :rejected, default: false

      t.timestamps
    end
  end
end
