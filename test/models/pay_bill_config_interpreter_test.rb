# == Schema Information
#
# Table name: pay_bill_config_interpreters
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  pay_bill_config_id :integer
#  user_id            :uuid
#
require "test_helper"

class PayBillConfigInterpreterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
