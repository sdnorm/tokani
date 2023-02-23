class AddTimeZonesToAgencyDetail < ActiveRecord::Migration[7.0]
  def change
    add_column :agency_details, :time_zones, :string, array: true
  end
end
