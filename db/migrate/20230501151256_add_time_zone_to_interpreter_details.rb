class AddTimeZoneToInterpreterDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :interpreter_details, :time_zone, :string
  end
end
