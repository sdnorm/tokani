# == Schema Information
#
# Table name: appointment_languages
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :bigint           not null
#  language_id    :bigint           not null
#
# Indexes
#
#  index_appointment_languages_on_appointment_id  (appointment_id)
#  index_appointment_languages_on_language_id     (language_id)
#
class AppointmentLanguage < ApplicationRecord
  belongs_to :appointment
  belongs_to :language

  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :appointment_languages, partial: "appointment_languages/index", locals: {appointment_language: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :appointment_languages, target: dom_id(self, :index) }
end
