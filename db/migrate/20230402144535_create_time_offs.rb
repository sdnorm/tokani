class CreateTimeOffs < ActiveRecord::Migration[7.0]
  def change
    create_table :time_offs do |t|
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.string :reason
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid

      t.timestamps

      t.check_constraint "start_datetime < end_datetime", name: "check_valid_datetime_range"
    end
  end
end
