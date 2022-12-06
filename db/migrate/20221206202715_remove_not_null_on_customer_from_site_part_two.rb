class RemoveNotNullOnCustomerFromSitePartTwo < ActiveRecord::Migration[7.0]
  def change
    change_column_null :sites, :customer_id, :false
  end
end
