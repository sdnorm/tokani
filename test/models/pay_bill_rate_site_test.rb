# == Schema Information
#
# Table name: pay_bill_rate_sites
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pay_bill_rate_id :integer
#  site_id          :uuid
#
require "test_helper"

class PayBillRateSiteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
