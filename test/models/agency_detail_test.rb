# == Schema Information
#
# Table name: agency_details
#
#  id                             :bigint           not null, primary key
#  company_website                :string
#  phone_number                   :string
#  primary_contact_email          :string
#  primary_contact_first_name     :string
#  primary_contact_last_name      :string
#  primary_contact_phone_number   :string
#  primary_contact_title          :string
#  secondary_contact_email        :string
#  secondary_contact_first_name   :string
#  secondary_contact_last_name    :string
#  secondary_contact_phone_number :string
#  secondary_contact_title        :string
#  time_zone                      :string
#  time_zones                     :string           is an Array
#  url                            :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  agency_id                      :uuid
#
# Indexes
#
#  index_agency_details_on_agency_id  (agency_id)
#
# Foreign Keys
#
#  fk_rails_...  (agency_id => accounts.id)
#
require "test_helper"

class AgencyDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
