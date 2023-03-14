# == Schema Information
#
# Table name: pay_rate_interpreters
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  interpreter_id :uuid
#  pay_rate_id    :integer
#
class PayRateInterpreter < ApplicationRecord
  belongs_to :pay_rate
  belongs_to :interpreter
end
