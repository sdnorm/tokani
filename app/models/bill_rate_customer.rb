# == Schema Information
#
# Table name: bill_rate_customers
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  bill_rate_id :integer
#  customer_id  :uuid
#
class BillRateCustomer < ApplicationRecord
  belongs_to :bill_rate
  belongs_to :customer, class_name: "Account", foreign_key: :customer_id
end
