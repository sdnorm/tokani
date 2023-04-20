class AddDateRangeToTimeOffs < ActiveRecord::Migration[7.0]
  def change
    add_column :time_offs, :date_range, :tsrange
  end
end
