# == Schema Information
#
# Table name: accounts
#
#  id                  :uuid             not null, primary key
#  account_users_count :integer          default(0)
#  agency              :boolean
#  billing_email       :string
#  customer            :boolean          default(FALSE)
#  domain              :string
#  extra_billing_info  :text
#  is_active           :boolean          default(TRUE)
#  name                :string           not null
#  personal            :boolean          default(FALSE)
#  subdomain           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :uuid
#
# Indexes
#
#  index_accounts_on_created_at  (created_at)
#  index_accounts_on_owner_id    (owner_id)
#
class Customer < Account
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :customers, partial: "customers/index", locals: {customer: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :customers, target: dom_id(self, :index) }

  before_create :set_customer_flag
  # belongs_to :customer_category
  has_many :sites
  has_many :providers
  has_many :recipients
  has_many :requestors

  has_many :bill_rate_customers, dependent: :destroy
  has_many :bill_rates, through: :bill_rate_customers, validate: false, class_name: "BillRate", foreign_key: :bill_rate_id

  has_one :customer_detail, dependent: :destroy, inverse_of: :customer
  validates_presence_of :customer_detail
  accepts_nested_attributes_for :customer_detail

  has_one :physical_address, -> { where(address_type: :physical) }, class_name: "Address", as: :addressable
  validates_presence_of :physical_address
  accepts_nested_attributes_for :physical_address

  # move to job so it retries
  def create_user_and_owner
    user = User.create(
      name: customer_detail.contact_name,
      email: customer_detail.email,
      password: SecureRandom.alphanumeric,
      terms_of_service: true,
      accepted_terms_at: Time.current
    )
    update(owner_id: user.id)
    account_users.create(user: user, roles: {"customer_admin" => true})
    RequestorDetail.create(
      allow_offsite: true,
      allow_view_docs: true,
      allow_view_checklist: true,
      primary_phone: customer_detail.phone,
      customer_id: customer_detail.customer_id,
      requestor_id: user.id,
      requestor_type: 4
    )
    CustomerRequestor.create(customer_id: customer_detail.customer_id, requestor_id: user.id)

    AgencyCustomerCreationMailer.welcome(user, self).deliver_later
  end

  private

  def set_customer_flag
    self.customer = true
  end
end
