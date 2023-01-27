# == Schema Information
#
# Table name: appointment_statuses
#
#  id          :bigint           not null, primary key
#  appointment :uuid             not null
#  current     :boolean
#  name        :integer
#  user        :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class AppointmentStatus < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :appointment_statuses, partial: "appointment_statuses/index", locals: {appointment_status: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :appointment_statuses, target: dom_id(self, :index) }

  belongs_to :user
  belongs_to :appointment

  enum name: {
    created: 1,
    rejected: 2,
    offered: 3,
    scheduled: 4,
    cancelled: 5,
    finished: 6,
    verified: 7,
    exported: 8,
    expired: 9
  }

  def changed_by
    user
  end
end
