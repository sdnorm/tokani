# == Schema Information
#
# Table name: departments
#
#  id                   :uuid             not null, primary key
#  accounting_unit_code :string
#  accounting_unit_desc :text
#  is_active            :boolean          default(TRUE), not null
#  location             :text
#  name                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  backport_id          :integer
#  site_id              :uuid             not null
#
# Indexes
#
#  index_departments_on_site_id  (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (site_id => sites.id)
#
class Department < ApplicationRecord
  belongs_to :site
  has_many :providers

  validates :name, uniqueness: {scope: :site_id}
end
