class AddFillRateReportFields < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :customer_id, :uuid
    add_column :reports, :interpreter_id, :uuid
  end
end
