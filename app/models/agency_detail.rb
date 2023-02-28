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
class AgencyDetail < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :agency_details, partial: "agency_details/index", locals: {agency_detail: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :agency_details, target: dom_id(self, :index) }

  belongs_to :agency, inverse_of: :agency_detail, optional: true

  validates_presence_of :primary_contact_first_name, :primary_contact_email, :primary_contact_title, :phone_number
  validates :phone_number, phone: {possible: true, allow_blank: true, message: "Phone number is invalid, please use 222-222-2222"}
  validates :primary_contact_email, email: true
  validates :secondary_contact_email, email: true, allow_blank: true
end
