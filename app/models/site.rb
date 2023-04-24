# == Schema Information
#
# Table name: sites
#
#  id            :uuid             not null, primary key
#  active        :boolean          default(TRUE)
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
#  account_id    :uuid
#  backport_id   :bigint
#  customer_id   :uuid             not null
#
# Indexes
#
#  index_sites_on_account_id   (account_id)
#  index_sites_on_backport_id  (backport_id)
#  index_sites_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Site < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :sites, partial: "sites/index", locals: {site: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :sites, target: dom_id(self, :index) }

  validates :account_id, presence: true
  validates :customer_id, presence: true

  belongs_to :account, dependent: :destroy
  belongs_to :customer, class_name: "Account", foreign_key: "customer_id"
  has_many :departments, dependent: :destroy
  has_many :providers
  has_many :requestor_details
  has_many :appointments, dependent: :destroy

  accepts_nested_attributes_for :departments, reject_if: :all_blank

  validates :name, presence: true
  validates :contact_name, presence: true
  validates :email, presence: true
  validates :contact_phone, phone: {possible: true, allow_blank: true, message: "Phone number is invalid, please use format 222-222-2222"}
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
end
