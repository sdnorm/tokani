class ChangePayCustomerOwnerIdToUuid < ActiveRecord::Migration[7.0]
  def change
    # change_column :pay_customers, :owner_id, :uuid, using: "owner_id::uuid"
  end
end
