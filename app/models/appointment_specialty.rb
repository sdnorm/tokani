# == Schema Information
#
# Table name: appointment_specialties
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :bigint           not null
#  specialty_id   :bigint           not null
#
# Indexes
#
#  index_appointment_specialties_on_appointment_id  (appointment_id)
#  index_appointment_specialties_on_specialty_id    (specialty_id)
#
# Foreign Keys
#
#  fk_rails_...  (appointment_id => appointments.id)
#  fk_rails_...  (specialty_id => specialties.id)
#
class AppointmentSpecialty < ApplicationRecord
  belongs_to :appointment
  belongs_to :specialty

  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :appointment_specialties, partial: "appointment_specialties/index", locals: {appointment_specialty: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :appointment_specialties, target: dom_id(self, :index) }
end
