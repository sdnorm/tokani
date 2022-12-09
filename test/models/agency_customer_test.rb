# == Schema Information
#
# Table name: agency_customers
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  agency_id   :uuid             not null
#  customer_id :uuid             not null
#
# Indexes
#
#  index_agency_customers_on_agency_id    (agency_id)
#  index_agency_customers_on_customer_id  (customer_id)
#
require "test_helper"

class AgencyCustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
