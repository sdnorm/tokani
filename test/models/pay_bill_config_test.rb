# == Schema Information
#
# Table name: pay_bill_configs
#
#  id                                               :bigint           not null, primary key
#  afterhours_availability_end_seconds1             :integer
#  afterhours_availability_end_seconds2             :integer
#  afterhours_availability_start_seconds1           :integer
#  afterhours_availability_start_seconds2           :integer
#  billing_increment                                :integer
#  fixed_roundtrip_mileage                          :integer
#  is_active                                        :boolean          default(TRUE)
#  is_minutes_billed_appointment_duration           :boolean          default(FALSE)
#  is_minutes_billed_cancelled_appointment_duration :boolean          default(FALSE)
#  maximum_mileage                                  :integer
#  maximum_travel_time                              :integer
#  minimum_minutes_billed                           :integer
#  minimum_minutes_billed_cancelled_level_1         :integer
#  minimum_minutes_billed_cancelled_level_2         :integer
#  minimum_minutes_paid                             :integer
#  minimum_minutes_paid_cancelled_level_1           :integer
#  minimum_minutes_paid_cancelled_level_2           :integer
#  name                                             :string
#  trigger_for_billing_increment                    :integer
#  trigger_for_cancel_level1                        :integer
#  trigger_for_cancel_level2                        :integer
#  trigger_for_discount_rate                        :integer
#  trigger_for_mileage                              :integer
#  trigger_for_rush_rate                            :integer
#  trigger_for_travel_time                          :integer
#  weekend_availability_end_seconds1                :integer
#  weekend_availability_end_seconds2                :integer
#  weekend_availability_start_seconds1              :integer
#  weekend_availability_start_seconds2              :integer
#  created_at                                       :datetime         not null
#  updated_at                                       :datetime         not null
#  account_id                                       :uuid
#
require "test_helper"

class PayBillConfigTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
