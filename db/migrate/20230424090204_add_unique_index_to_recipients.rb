class AddUniqueIndexToRecipients < ActiveRecord::Migration[7.0]
  def up
    add_index :recipients, [:email, :customer_id], unique: true, name: "unique_email_customer_id"
  end

  def down
    remove_index :recipients, name: "unique_email_customer_id"
  end
end
