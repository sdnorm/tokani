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
  belongs_to :interpreter, class_name: "User", foreign_key: :user_id
end
