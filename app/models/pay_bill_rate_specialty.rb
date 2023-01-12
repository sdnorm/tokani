# == Schema Information
#
# Table name: pay_bill_rate_specialties
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pay_bill_rate_id :integer
#  specialty_id     :integer
#
class PayBillRateSpecialty < ApplicationRecord
  belongs_to :pay_bill_rate
  belongs_to :specialty
end
