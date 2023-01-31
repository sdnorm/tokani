class AddCustomerCategoryReferenceToAgencyCustomer < ActiveRecord::Migration[7.0]
  def change
    add_reference :agency_customers, :customer_category, foreign_key: true
  end
end
