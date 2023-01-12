# == Schema Information
#
# Table name: pay_bill_rate_customers
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :uuid
#  pay_bill_rate_id :integer
#
require "test_helper"

class PayBillRateCustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
