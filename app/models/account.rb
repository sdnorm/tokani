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

class Account < ApplicationRecord
  RESERVED_DOMAINS = [Jumpstart.config.domain]
  RESERVED_SUBDOMAINS = %w[app help support]

  belongs_to :owner, class_name: "User", optional: true
  has_many :account_invitations, dependent: :destroy
  has_many :account_users, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :users, through: :account_users
  has_many :addresses, as: :addressable, dependent: :destroy
  has_one :billing_address, -> { where(address_type: :billing) }, class_name: "Address", as: :addressable
  has_one :shipping_address, -> { where(address_type: :shipping) }, class_name: "Address", as: :addressable
  has_one :physical_address, -> { where(address_type: :physical) }, class_name: "Address", as: :addressable

  has_many :appointments, foreign_key: :agency_id
  has_many :customer_appointments, class_name: "Appointment", foreign_key: :customer_id

  has_many :sites, dependent: :destroy, foreign_key: :customer_id
  has_many :account_sites, dependent: :destroy, foreign_key: :account_id, class_name: "Site"

  has_many :agency_customers, foreign_key: :agency_id
  has_many :customers, through: :agency_customers

  has_many :customer_agencies, foreign_key: :customer_id
  has_many :agencies, through: :customer_agencies

  has_many :pay_bill_rates
  has_many :pay_bill_configs

  has_one :customer_detail, foreign_key: :customer_id, dependent: :destroy, inverse_of: :customer, autosave: true

  has_many :specialties, dependent: :destroy, foreign_key: :account_id

  has_many :languages, foreign_key: :account_id
  has_many :account_languages, dependent: :destroy, foreign_key: :account_id, class_name: "Language"

  has_many :requestor_details, dependent: :destroy, foreign_key: :customer_id
  has_many :process_batches, dependent: :destroy
  has_many :providers, dependent: :destroy, foreign_key: :customer_id
  has_many :recipients, dependent: :destroy, foreign_key: :customer_id
  has_many :process_batches, dependent: :destroy
  has_many :rate_criteria, dependent: :destroy

  accepts_nested_attributes_for :physical_address, :customer_detail

  scope :personal, -> { where(personal: true) }
  scope :impersonal, -> { where(personal: false) }
  scope :sorted, -> { order(personal: :desc, name: :asc) }

  has_noticed_notifications
  has_one_attached :avatar
  pay_customer stripe_attributes: :stripe_attributes

  validates :name, presence: true
  validates :domain, exclusion: {in: RESERVED_DOMAINS, message: :reserved}
  validates :subdomain, exclusion: {in: RESERVED_SUBDOMAINS, message: :reserved}, format: {with: /\A[a-zA-Z0-9]+[a-zA-Z0-9\-_]*[a-zA-Z0-9]+\Z/, message: :format, allow_blank: true}
  validates :avatar, resizable_image: true

  def account_interpreters
    interpreter_account_ids = AccountUser.where(roles: {interpreter: true}).where(account_id: id).pluck(:user_id)
    User.includes(:interpreter_detail).where(id: interpreter_account_ids)
  end

  def find_or_build_billing_address
    billing_address || build_billing_address
  end

  # def email
  #   account_users.includes(:user).order(created_at: :asc).first.user.email
  # end

  def impersonal?
    !personal?
  end

  def personal_account_for?(user)
    personal? && owner_id == user.id
  end

  def owner?(user)
    owner_id == user.id
  end

  def interpreters
    User.where(id: account_users.interpreter.pluck(:user_id))
  end
  # stop auto admin

  # An account can be transferred by the owner if it:
  # * Isn't a personal account
  # * Has more than one user in it
  def can_transfer?(user)
    impersonal? && owner?(user) && users.size >= 2
  end

  # Transfers ownership of the account to a user
  # The new owner is automatically granted admin access to allow editing of the account
  # Previous owner roles are unchanged
  def transfer_ownership(user_id)
    previous_owner = owner
    account_user = account_users.find_by!(user_id: user_id)
    user = account_user.user

    ApplicationRecord.transaction do
      # account_user.update!(admin: true)
      update!(owner: user)

      # Add any additional logic for updating records here
    end

    # Notify the new owner of the change
    Account::OwnershipNotification.with(account: self, previous_owner: previous_owner.name).deliver_later(user)
  rescue
    false
  end

  # Uncomment this to add generic trials (without a card or plan)
  #
  # after_create :start_trial
  #
  # def start_trial(length: 14.days)
  #   trial_ends_at = length.from_now
  #   set_payment_processor :fake_processor, allow_fake: true
  #   payment_processor.subscribe(plan: Plan.free.fake_processor_id, trial_ends_at: trial_ends_at, ends_at: trial_ends_at)
  # end

  # If you need to create some associated records when an Account is created,
  # use a `with_tenant` block to change the current tenant temporarily
  #
  # after_create do
  #   ActsAsTenant.with_tenant(self) do
  #     association.create(name: "example")
  #   end
  # end

  private

  # Attributes to sync to the Stripe Customer
  def stripe_attributes(*args)
    {address: billing_address&.to_stripe}.compact
  end
end
