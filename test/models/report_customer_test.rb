# == Schema Information
#
# Table name: report_customers
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :uuid
#  report_id  :integer
#
require "test_helper"

class ReportCustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
