class AddAgencyAndCustomerRelationshipsToSite < ActiveRecord::Migration[7.0]
  def change
    add_reference :sites, :customer, null: false, foreign_key: {to_table: :accounts}, index: true
  end
end
