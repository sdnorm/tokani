# == Schema Information
#
# Table name: appointments
#
#  id                       :bigint           not null, primary key
#  admin_notes              :text
#  billing_notes            :text
#  cancel_reason_code       :integer
#  canceled_by              :integer
#  cancelled_at             :datetime
#  confirmation_date        :datetime
#  confirmation_notes       :text
#  confirmation_phone       :string
#  details                  :text
#  duration                 :integer
#  finish_time              :datetime
#  gender_req               :integer
#  home_health_appointment  :boolean
#  interpreter_type         :integer
#  lock_version             :integer
#  modality                 :integer
#  notes                    :text
#  processed_by_customer    :boolean          default(FALSE)
#  processed_by_interpreter :boolean          default(FALSE)
#  ref_number               :string
#  start_time               :datetime
#  status                   :boolean
#  sub_type                 :integer
#  time_zone                :string
#  total_billed             :decimal(, )
#  total_paid               :decimal(, )
#  video_link               :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  agency_id                :uuid
#  customer_id              :uuid
#  department_id            :uuid
#  interpreter_id           :uuid
#  language_id              :bigint           not null
#  pay_bill_config_id       :integer
#  pay_bill_rate_id         :integer
#  provider_id              :uuid
#  recipient_id             :uuid
#  requestor_id             :uuid
#  site_id                  :uuid
#
# Indexes
#
#  index_appointments_on_agency_id       (agency_id)
#  index_appointments_on_customer_id     (customer_id)
#  index_appointments_on_department_id   (department_id)
#  index_appointments_on_interpreter_id  (interpreter_id)
#  index_appointments_on_provider_id     (provider_id)
#  index_appointments_on_recipient_id    (recipient_id)
#  index_appointments_on_requestor_id    (requestor_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (provider_id => providers.id)
#  fk_rails_...  (recipient_id => recipients.id)
#  fk_rails_...  (requestor_id => users.id)
#
require "test_helper"

class AppointmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
