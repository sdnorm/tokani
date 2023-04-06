class AddSiteReferenceToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :appointments, :sites, column: :site_id
  end
end
