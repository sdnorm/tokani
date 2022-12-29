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
require "test_helper"

class AppointmentSpecialtyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
