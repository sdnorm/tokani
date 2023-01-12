# == Schema Information
#
# Table name: pay_bill_rate_sites
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pay_bill_rate_id :integer
#  site_id          :uuid
#
class PayBillRateSite < ApplicationRecord
  belongs_to :pay_bill_rate
  belongs_to :site
end
