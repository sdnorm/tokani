class DropOldPayBillTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :pay_bill_config_customers
    drop_table :pay_bill_config_interpreters
    drop_table :pay_bill_configs

    drop_table :pay_bill_rate_customers
    drop_table :pay_bill_rate_departments
    drop_table :pay_bill_rate_interpreters
    drop_table :pay_bill_rate_interpreter_types
    drop_table :pay_bill_rate_languages
    drop_table :pay_bill_rate_sites
    drop_table :pay_bill_rate_specialties
    drop_table :pay_bill_rates
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
