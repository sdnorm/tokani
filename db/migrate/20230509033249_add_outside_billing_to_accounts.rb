class AddOutsideBillingToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :outside_billing, :boolean, default: false
  end
end
