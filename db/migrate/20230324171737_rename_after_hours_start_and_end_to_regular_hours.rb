class RenameAfterHoursStartAndEndToRegularHours < ActiveRecord::Migration[7.0]
  def change
    rename_column :bill_rates, :after_hours_start_seconds, :regular_hours_start_seconds
    rename_column :bill_rates, :after_hours_end_seconds, :regular_hours_end_seconds
  end
end
