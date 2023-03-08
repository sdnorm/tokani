# == Schema Information
#
# Table name: customer_agencies
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  agency_id   :uuid
#  customer_id :uuid
#
# Indexes
#
#  index_customer_agencies_on_agency_id    (agency_id)
#  index_customer_agencies_on_customer_id  (customer_id)
#
class CustomerAgency < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :customer_agencies, partial: "customer_agencies/index", locals: {customer_agency: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :customer_agencies, target: dom_id(self, :index) }

  belongs_to :agency, class_name: "Account", foreign_key: "agency_id"
  belongs_to :customer, class_name: "Account", foreign_key: "customer_id"
end
