class AddInterpreterToAppoinment < ActiveRecord::Migration[7.0]
  def change
    add_reference :appointments, :interpreter, foreign_key: {to_table: :users}, index: true
  end
end
