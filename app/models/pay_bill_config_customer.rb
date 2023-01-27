# == Schema Information
#
# Table name: pay_bill_config_customers
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :uuid
#  pay_bill_config_id :integer
#
class PayBillConfigCustomer < ApplicationRecord
  belongs_to :pay_bill_config
  belongs_to :customer, class_name: "Account", foreign_key: :account_id
end
