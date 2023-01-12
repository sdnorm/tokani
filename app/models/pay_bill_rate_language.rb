# == Schema Information
#
# Table name: pay_bill_rate_languages
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  language_id      :integer
#  pay_bill_rate_id :integer
#
class PayBillRateLanguage < ApplicationRecord
  belongs_to :pay_bill_rate
  belongs_to :language
end
