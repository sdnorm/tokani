# == Schema Information
#
# Table name: pay_bill_rate_customers
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :uuid
#  pay_bill_rate_id :integer
#
class PayBillRateCustomer < ApplicationRecord
  belongs_to :pay_bill_rate
  belongs_to :account
end
