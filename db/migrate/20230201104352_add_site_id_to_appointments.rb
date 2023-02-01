class AddSiteIdToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :site_id, :uuid
  end
end
