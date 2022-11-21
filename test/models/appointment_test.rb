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
#
require "test_helper"

class AppointmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
