# == Schema Information
#
# Table name: appointments
#
#  id                      :bigint           not null, primary key
#  admin_notes             :text
#  billing_notes           :text
#  cancel_reason_code      :integer
#  canceled_by             :integer
#  confirmation_date       :datetime
#  confirmation_notes      :text
#  confirmation_phone      :string
#  details                 :text
#  duration                :integer
#  finish_time             :datetime
#  gender_req              :integer
#  home_health_appointment :boolean
#  interpreter_type        :integer
#  lock_version            :integer
#  modality                :integer
#  notes                   :text
#  ref_number              :string
#  start_time              :datetime
#  status                  :boolean
#  sub_type                :integer
#  time_zone               :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  agency_id               :uuid
#  customer_id             :uuid
#  interpreter_id          :uuid
#
# Indexes
#
#  index_appointments_on_agency_id       (agency_id)
#  index_appointments_on_customer_id     (customer_id)
#  index_appointments_on_interpreter_id  (interpreter_id)
#
class Appointment < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :appointments, partial: "appointments/index", locals: {appointment: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :appointments, target: dom_id(self, :index) }

  has_many :appointment_languages, dependent: :destroy
  has_many :appointment_specialties, dependent: :destroy
  has_many :specialties, through: :appointment_specialties
  has_many :appointment_statuses, dependent: :destroy

  belongs_to :agency, class_name: "Account"
  belongs_to :customer, class_name: "Account", optional: true
  belongs_to :interpreter, class_name: "User", optional: true

  def status
    appointment_statuses.current.name
  end
end
