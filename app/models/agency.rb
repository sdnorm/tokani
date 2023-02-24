# == Schema Information
#
# Table name: accounts
#
#  id                 :uuid             not null, primary key
#  agency             :boolean
#  customer           :boolean          default(FALSE)
#  domain             :string
#  extra_billing_info :text
#  is_active          :boolean          default(TRUE)
#  name               :string           not null
#  personal           :boolean          default(FALSE)
#  subdomain          :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  owner_id           :uuid
#
# Indexes
#
#  index_accounts_on_created_at  (created_at)
#  index_accounts_on_owner_id    (owner_id)
#
class Agency < Account
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :agencies, partial: "agencies/index", locals: {agency: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :agencies, target: dom_id(self, :index) }

  before_create :set_agency_flag

  def create_owner_account_from_primary_contact
    user = User.create(
      email: agency_detail.primary_contact_email,
      password: SecureRandom.alphanumeric,
      first_name: agency_detail.primary_contact_first_name,
      last_name: agency_detail.primary_contact_last_name,
      terms_of_service: true,
      accepted_terms_at: Time.current
    )
    update(owner_id: user.id)
    account_users.create(user: user, roles: {"agency_admin" => true})
    TokaniAgencyCreationMailer.welcome(user).deliver_later
  end

  has_one :agency_detail, dependent: :destroy, inverse_of: :agency
  validates_presence_of :agency_detail
  accepts_nested_attributes_for :agency_detail

  has_one :physical_address, -> { where(address_type: :physical) }, class_name: "Address", as: :addressable
  validates_presence_of :physical_address
  accepts_nested_attributes_for :physical_address

  private

  def set_agency_flag
    self.agency = true
  end
end
