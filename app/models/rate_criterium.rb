class RateCriterium < ApplicationRecord
  belongs_to :account

  enum type_key: { sites_departments: 0, specialty: 1, language: 2, interpreter_type: 3 }

  scope :sorted, -> { order(sort_order: :asc) }

end
