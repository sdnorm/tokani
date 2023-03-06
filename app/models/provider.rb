# == Schema Information
#
# Table name: providers
#
#  id            :uuid             not null, primary key
#  allow_email   :boolean
#  allow_text    :boolean
#  email         :string
#  first_name    :string
#  last_name     :string
#  primary_phone :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  customer_id   :uuid             not null
#  department_id :uuid
#  site_id       :uuid
#
# Indexes
#
#  index_providers_on_customer_id    (customer_id)
#  index_providers_on_department_id  (department_id)
#  index_providers_on_site_id        (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => accounts.id)
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (site_id => sites.id)
#
class Provider < ApplicationRecord
  belongs_to :site, optional: true # , dependent: :destroy
  belongs_to :department, optional: true # , dependent: :destroy
  belongs_to :customer, class_name: "Account", foreign_key: "customer_id", dependent: :destroy
  has_many :appointments
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :providers, partial: "providers/index", locals: {provider: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :providers, target: dom_id(self, :index) }

  validates :primary_phone, phone: {possible: true, allow_blank: false, message: "Phone number is invalid, please use format 222-222-2222"}
  validates :email, email: true
  validates :first_name, presence: {message: "field is required"}
  validates :last_name, presence: {message: "field is required"}
  validates :customer_id, presence: {message: "field is required"}

  def view_name
    "#{first_name} #{last_name}"
  end
end
