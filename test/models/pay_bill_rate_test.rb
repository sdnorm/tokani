# == Schema Information
#
# Table name: pay_bill_rates
#
#  id                       :bigint           not null, primary key
#  after_hours_bill_rate    :decimal(, )
#  after_hours_pay_rate     :decimal(, )
#  bill_rate                :decimal(, )
#  cancel_level_1_bill_rate :decimal(, )
#  cancel_level_1_pay_rate  :decimal(, )
#  cancel_level_2_bill_rate :decimal(, )
#  cancel_level_2_pay_rate  :decimal(, )
#  discount_bill_rate       :decimal(, )
#  discount_pay_rate        :decimal(, )
#  effective_date           :date
#  in_person                :boolean
#  interpreter_types        :jsonb
#  is_active                :boolean          default(TRUE)
#  is_default               :boolean
#  mileage_rate             :decimal(, )
#  name                     :string
#  pay_rate                 :decimal(, )
#  phone                    :boolean
#  rush_bill_rate           :decimal(, )
#  rush_pay_rate            :decimal(, )
#  travel_time_rate         :decimal(, )
#  video                    :boolean
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  account_id               :uuid
#
require "test_helper"

class PayBillRateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
