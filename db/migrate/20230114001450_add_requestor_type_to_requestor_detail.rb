class AddRequestorTypeToRequestorDetail < ActiveRecord::Migration[7.0]
  def change
    add_column :requestor_details, :requestor_type, :integer
  end
end
