# == Schema Information
#
# Table name: rate_criteria
#
#  id         :bigint           not null, primary key
#  name       :string
#  sort_order :integer          not null
#  type_key   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :uuid
#
# Indexes
#
#  index_rate_criteria_on_account_id  (account_id)
#
class RateCriterium < ApplicationRecord
  belongs_to :account

  enum type_key: {sites_departments: 0, specialty: 1, language: 2, interpreter_type: 3}

  scope :sorted, -> { order(sort_order: :asc) }
end
