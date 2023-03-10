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
class RequestorDetail < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :requestor_details, partial: "requestor_details/index", locals: {requestor_detail: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :requestor_details, target: dom_id(self, :index) }

  belongs_to :requestor, class_name: "User", foreign_key: "requestor_id", inverse_of: :requestor_detail

  belongs_to :site, optional: true
  belongs_to :department, optional: true
  belongs_to :customer, class_name: "Account", foreign_key: "customer_id"

  enum requestor_type: {site_admin: 1, site_member: 2, client: 3}
  validates :primary_phone, phone: {possible: true, allow_blank: false, message: "is invalid, please use format 222-222-2222"}
  validates :requestor_type, presence: {message: "is required"}
  validates :customer_id, presence: {message: "is required"}
end
