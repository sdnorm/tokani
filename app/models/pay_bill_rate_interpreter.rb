# == Schema Information
#
# Table name: pay_bill_rate_interpreters
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pay_bill_rate_id :integer
#  user_id          :uuid
#
class PayBillRateInterpreter < ApplicationRecord
  belongs_to :pay_bill_rate
  belongs_to :user
end
