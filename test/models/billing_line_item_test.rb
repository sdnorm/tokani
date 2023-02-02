# == Schema Information
#
# Table name: billing_line_items
#
#  id             :bigint           not null, primary key
#  amount         :decimal(, )
#  description    :string
#  hours          :decimal(, )
#  rate           :decimal(, )
#  type_key       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :integer
#
require "test_helper"

class BillingLineItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
