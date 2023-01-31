# == Schema Information
#
# Table name: customer_categories
#
#  id                 :bigint           not null, primary key
#  appointment_prefix :string
#  display_value      :string
#  is_active          :boolean
#  sort_order         :bigint
#  telephone_prefix   :string
#  video_prefix       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  backport_id        :bigint
#
# Indexes
#
#  index_customer_categories_on_backport_id    (backport_id)
#  index_customer_categories_on_display_value  (display_value)
#
require "test_helper"

class CustomerCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
