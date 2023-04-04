# == Schema Information
#
# Table name: customer_requestors
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  customer_id  :uuid
#  requestor_id :uuid
#
class CustomerRequestor < ApplicationRecord
  belongs_to :customer, class_name: "Account", foreign_key: :customer_id
  belongs_to :requestor, class_name: "User", foreign_key: :requestor_id
end
