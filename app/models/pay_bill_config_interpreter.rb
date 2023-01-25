# == Schema Information
#
# Table name: pay_bill_config_interpreters
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  pay_bill_config_id :integer
#  user_id            :uuid
#
class PayBillConfigInterpreter < ApplicationRecord
  belongs_to :pay_bill_config
  belongs_to :interpreter, class_name: "User", foreign_key: :user_id
end
