# == Schema Information
#
# Table name: report_customers
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :uuid
#  report_id  :integer
#
class ReportCustomer < ApplicationRecord
  belongs_to :report
  belongs_to :customer, class_name: "Account", foreign_key: :account_id
end
