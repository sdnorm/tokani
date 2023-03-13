# == Schema Information
#
# Table name: bill_rate_languages
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  bill_rate_id :integer
#  language_id  :integer
#
class BillRateLanguage < ApplicationRecord
  belongs_to :bill_rate
  belongs_to :language
end
