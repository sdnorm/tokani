# == Schema Information
#
# Table name: pay_rates
#
#  id                   :bigint           not null, primary key
#  after_hours_overage  :decimal(8, 2)
#  cancel_rate          :decimal(8, 2)
#  default_rate         :boolean          default(FALSE)
#  hourly_pay_rate      :decimal(8, 2)
#  in_person            :boolean          default(FALSE)
#  is_active            :boolean          default(TRUE)
#  minimum_time_charged :integer
#  name                 :string
#  phone                :boolean          default(FALSE)
#  rush_overage         :decimal(8, 2)
#  video                :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :uuid
#
require "test_helper"

class PayRateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
