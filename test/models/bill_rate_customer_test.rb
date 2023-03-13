# == Schema Information
#
# Table name: bill_rate_customers
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  bill_rate_id :integer
#  customer_id  :uuid
#
require "test_helper"

class BillRateCustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
