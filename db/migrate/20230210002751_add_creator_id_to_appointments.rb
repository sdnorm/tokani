class AddCreatorIdToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :creator_id, :uuid
  end
end
