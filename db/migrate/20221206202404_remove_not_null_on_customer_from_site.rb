class RemoveNotNullOnCustomerFromSite < ActiveRecord::Migration[7.0]
  def change
    change_column_null :sites, :customer_id, :true
  end
end
