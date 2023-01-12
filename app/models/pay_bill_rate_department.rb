# == Schema Information
#
# Table name: pay_bill_rate_departments
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  department_id    :uuid
#  pay_bill_rate_id :integer
#
class PayBillRateDepartment < ApplicationRecord
  belongs_to :pay_bill_rate
  belongs_to :department
end
