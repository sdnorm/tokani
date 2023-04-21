class AddDefaultValueToIsActiveInCustomerCategories < ActiveRecord::Migration[7.0]
  def up
    change_column :customer_categories, :is_active, :boolean, default: true
  end

  def down
    change_column :customer_categories, :is_active, :boolean, default: nil
  end
end
