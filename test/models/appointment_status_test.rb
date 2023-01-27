# == Schema Information
#
# Table name: appointment_statuses
#
#  id             :bigint           not null, primary key
#  current        :boolean
#  name           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :uuid             not null
#  user_id        :uuid             not null
#
require "test_helper"

class AppointmentStatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
