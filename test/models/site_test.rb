# == Schema Information
#
# Table name: sites
#
#  id            :bigint           not null, primary key
#  active        :boolean
#  address       :string
#  city          :string
#  contact_name  :string
#  contact_phone :string
#  email         :string
#  name          :string
#  notes         :text
#  state         :string
#  zip_code      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  backport_id   :bigint
#  customer_id   :uuid             not null
#
# Indexes
#
#  index_sites_on_backport_id  (backport_id)
#  index_sites_on_customer_id  (customer_id)
#
require "test_helper"

class SiteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
