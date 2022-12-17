# == Schema Information
#
# Table name: accounts
#
#  id                     :uuid             not null, primary key
#  address                :string
#  appointments_in_person :boolean          default(TRUE)
#  appointments_phone     :boolean          default(TRUE)
#  appointments_video     :boolean          default(TRUE)
#  city                   :string
#  contact_name           :string
#  customer               :boolean          default(FALSE)
#  domain                 :string
#  email                  :string
#  extra_billing_info     :text
#  fax                    :string
#  is_active              :boolean          default(TRUE)
#  name                   :string           not null
#  notes                  :text
#  personal               :boolean          default(FALSE)
#  phone                  :string
#  state                  :string
#  subdomain              :string
#  zip                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  owner_id               :uuid
#
# Indexes
#
#  index_accounts_on_created_at  (created_at)
#  index_accounts_on_owner_id    (owner_id)
#
require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
