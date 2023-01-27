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
require "test_helper"

class AppointmentStatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
