# == Schema Information
#
# Table name: time_offs
#
#  id             :bigint           not null, primary key
#  end_datetime   :datetime
#  reason         :string
#  start_datetime :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_time_offs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class TimeOff < ApplicationRecord
  belongs_to :interpreter, foreign_key: "user_id", class_name: "User"

  validate :start_is_less_than_end
  validates_presence_of :start_datetime, :end_datetime

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_append_later_to :time_offs, target: "time_offs_table", locals: {time_off: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :time_offs, target: dom_id(self, :index) }

  private

  def start_is_less_than_end
    return false if start_datetime.blank? || end_datetime.blank?

    unless start_datetime < end_datetime
      errors.add(:start_datetime, "Must be before End Date Time")
      errors.add(:end_datetime, "Must be after Start Date Time")
      return false
    end
    true
  end
end
