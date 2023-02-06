class AddFieldsToAppointmentsPartTwo < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :video_link, :string
    add_reference :appointments, :department, foreign_key: true, type: :uuid
    add_reference :appointments, :provider, foreign_key: true, type: :uuid
    add_reference :appointments, :recipient, foreign_key: true, type: :uuid
    add_reference :appointments, :requestor, foreign_key: {to_table: :users}, index: true, type: :uuid
  end
end
