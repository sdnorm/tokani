# == Schema Information
#
# Table name: accounts
#
#  id                  :uuid             not null, primary key
#  account_users_count :integer          default(0)
#  agency              :boolean
#  billing_email       :string
#  customer            :boolean          default(FALSE)
#  domain              :string
#  extra_billing_info  :text
#  is_active           :boolean          default(TRUE)
#  name                :string           not null
#  personal            :boolean          default(FALSE)
#  subdomain           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :uuid
#
# Indexes
#
#  index_accounts_on_created_at  (created_at)
#  index_accounts_on_owner_id    (owner_id)
#
require "test_helper"

class AgencyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
