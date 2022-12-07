# == Schema Information
#
# Table name: sites
#
#  id            :bigint           not null, primary key
#  active        :boolean
#  address       :string
#  city          :string
#  contact_name  :string
#  contact_phone :string
#  email         :string
#  name          :string
#  notes         :text
#  state         :string
#  zip_code      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  backport_id   :bigint
#  customer_id   :bigint
#
# Indexes
#
#  index_sites_on_backport_id  (backport_id)
#  index_sites_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => accounts.id)
#
class Site < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :sites, partial: "sites/index", locals: {site: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :sites, target: dom_id(self, :index) }

  validates :customer_id, presence: true

  belongs_to :customer, class_name: "Account"
end
