# == Schema Information
#
# Table name: pay_bill_rate_interpreter_types
#
#  id               :bigint           not null, primary key
#  interpreter_type :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pay_bill_rate_id :integer
#
class PayBillRateInterpreterType < ApplicationRecord
  belongs_to :pay_bill_rate
end
