class AddBooleanForCustomerOnAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :customer, :boolean, default: false
  end
end
