# == Schema Information
#
# Table name: bill_rates
#
#  id                        :bigint           not null, primary key
#  after_hours_end_seconds   :integer
#  after_hours_overage       :decimal(8, 2)
#  after_hours_start_seconds :integer
#  cancel_rate               :decimal(8, 2)
#  cancel_rate_trigger       :integer
#  default_rate              :boolean          default(FALSE)
#  hourly_bill_rate          :decimal(8, 2)
#  in_person                 :boolean          default(FALSE)
#  is_active                 :boolean          default(TRUE)
#  minimum_time_charged      :integer
#  name                      :string
#  phone                     :boolean          default(FALSE)
#  round_increment           :integer
#  round_time                :integer
#  rush_overage              :decimal(8, 2)
#  rush_overage_trigger      :integer
#  video                     :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  account_id                :uuid
#
require "test_helper"

class BillRateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
