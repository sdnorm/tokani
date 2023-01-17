# == Schema Information
#
# Table name: requestor_details
#
#  id                   :bigint           not null, primary key
#  allow_offsite        :boolean
#  allow_view_checklist :boolean
#  allow_view_docs      :boolean
#  primary_phone        :string
#  requestor_type       :integer
#  work_phone           :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  customer_id          :uuid
#  department_id        :uuid
#  requestor_id         :uuid             not null
#  site_id              :uuid
#
# Indexes
#
#  index_requestor_details_on_requestor_id  (requestor_id)
#
require "test_helper"

class RequestorDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
