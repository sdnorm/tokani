class AddRequestorsThroughTable < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_requestors do |t|
      t.uuid :customer_id
      t.uuid :requestor_id

      t.timestamps
    end
  end
end
