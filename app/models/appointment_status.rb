# == Schema Information
#
# Table name: appointment_statuses
#
#  id             :bigint           not null, primary key
#  current        :boolean
#  name           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :bigint
#  user_id        :uuid             not null
#
# Indexes
#
#  index_appointment_statuses_on_appointment_id  (appointment_id)
#
# Foreign Keys
#
#  fk_rails_...  (appointment_id => appointments.id)
#
class AppointmentStatus < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :appointment_statuses, partial: "appointment_statuses/index", locals: {appointment_status: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :appointment_statuses, target: dom_id(self, :index) }

  belongs_to :user
  belongs_to :appointment

  before_create :set_current

  # scope :current, -> (appointment) { find_by(appointment_id: appointment, current: true) }
  scope :current, -> { find_by(current: true) }
  scope :by_appoitnment, ->(appointment_id) { where(appointment_id: appointment_id) }

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

  def set_current
    # by_appointment(self.appointment_id).update_all(current: false)
    AppointmentStatus.where(appointment_id: appointment_id).update_all(current: false)
    self.current = true
  end
end
