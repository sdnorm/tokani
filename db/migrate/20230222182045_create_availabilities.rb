class CreateAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :availabilities do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.string :time_zone
      t.integer :wday
      t.integer :start_seconds
      t.integer :end_seconds
      t.boolean :in_person
      t.boolean :phone
      t.boolean :video
      t.integer :backport_id

      t.timestamps

      t.check_constraint "start_seconds >= 0 AND start_seconds < 86400", name: "check_start_seconds"
      t.check_constraint "end_seconds >= 0 AND end_seconds < 86400", name: "check_end_seconds"
      t.check_constraint "start_seconds < end_seconds", name: "check_valid_time_range"
      t.index [:user_id, :start_seconds, :end_seconds], name: "user_start_secs_end_secs_ix"
    end
  end
end
