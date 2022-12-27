# == Schema Information
#
# Table name: agency_customers
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  agency_id   :uuid
#  customer_id :uuid
#
# Indexes
#
#  index_agency_customers_on_agency_id    (agency_id)
#  index_agency_customers_on_customer_id  (customer_id)
#
class AgencyCustomer < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :agency_customers, partial: "agency_customers/index", locals: {agency_customer: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :agency_customers, target: dom_id(self, :index) }

  belongs_to :agency, class_name: "Account", foreign_key: "agency_id"
  belongs_to :customer, class_name: "Account", foreign_key: "customer_id"
end
