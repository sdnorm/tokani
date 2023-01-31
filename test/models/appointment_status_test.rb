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
require "test_helper"

class AppointmentStatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
