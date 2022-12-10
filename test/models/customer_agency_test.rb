# == Schema Information
#
# Table name: customer_agencies
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  agency_id   :uuid             not null
#  customer_id :uuid             not null
#
# Indexes
#
#  index_customer_agencies_on_agency_id    (agency_id)
#  index_customer_agencies_on_customer_id  (customer_id)
#
require "test_helper"

class CustomerAgencyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
