class AgencyReferenceOnAgencyInake < ActiveRecord::Migration[7.0]
  def change
    add_reference :agency_details, :agency, foreign_key: {to_table: :accounts}, index: true, type: :uuid
  end
end
