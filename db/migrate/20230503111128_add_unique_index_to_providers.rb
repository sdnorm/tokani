class AddUniqueIndexToProviders < ActiveRecord::Migration[7.0]
  def up
    add_index :providers, [:email, :customer_id], unique: true, name: "unique_provider_email_customer_id"
  end

  def down
    remove_index :providers, name: "unique_provider_email_customer_id"
  end
end
