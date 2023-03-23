class AddTimeZoneToAgencyDetail < ActiveRecord::Migration[7.0]
  def change
    add_column :agency_details, :time_zone, :string
  end
end
