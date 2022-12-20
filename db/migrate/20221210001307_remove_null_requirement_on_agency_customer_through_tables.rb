class RemoveNullRequirementOnAgencyCustomerThroughTables < ActiveRecord::Migration[7.0]
  def change
    change_column_null :agency_customers, :agency_id, true
    change_column_null :agency_customers, :customer_id, true
    change_column_null :customer_agencies, :agency_id, true
    change_column_null :customer_agencies, :customer_id, true
  end
end
