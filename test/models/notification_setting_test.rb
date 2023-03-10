# == Schema Information
#
# Table name: notification_settings
#
#  id                    :bigint           not null, primary key
#  appointment_cancelled :boolean          default(TRUE)
#  appointment_offered   :boolean          default(TRUE)
#  appointment_scheduled :boolean          default(TRUE)
#  sms                   :integer          default("no_sms")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :uuid
#
require "test_helper"

class NotificationSettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
