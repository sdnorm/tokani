class AddCustomerCategoryToCustomerDetail < ActiveRecord::Migration[7.0]
  def change
    add_reference :customer_details, :customer_category, null: false, foreign_key: true
  end
end
