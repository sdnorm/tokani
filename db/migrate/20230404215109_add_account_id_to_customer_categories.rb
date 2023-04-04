class AddAccountIdToCustomerCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :customer_categories, :account_id, :uuid
  end
end
