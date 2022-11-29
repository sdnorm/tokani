class AddAgencyAdminBooleanToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :agency_admin, :boolean
  end
end
