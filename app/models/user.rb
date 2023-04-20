# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  accepted_privacy_at    :datetime
#  accepted_terms_at      :datetime
#  admin                  :boolean
#  agency_admin           :boolean
#  announcements_read_at  :datetime
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_name              :string
#  last_otp_timestep      :integer
#  otp_backup_codes       :text
#  otp_required_for_login :boolean
#  otp_secret             :string
#  preferred_language     :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  time_zone              :string
#  tokani_admin           :boolean
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  include ActionText::Attachable
  include PgSearch::Model
  include TwoFactorAuthentication
  include UserAccounts
  include UserAgreements

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, andle :trackable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :omniauthable

  has_noticed_notifications
  has_person_name

  pg_search_scope :search_by_full_name, against: [:first_name, :last_name], using: {tsearch: {prefix: true}}

  # ActiveStorage Associations
  has_one_attached :avatar

  # Associations
  has_many :api_tokens, dependent: :destroy
  has_many :connected_accounts, as: :owner, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :notification_tokens, dependent: :destroy

  has_many :interpreter_languages, dependent: :destroy, inverse_of: :interpreter, foreign_key: :interpreter_id
  has_many :languages, through: :interpreter_languages

  has_one :requestor_detail, dependent: :destroy, foreign_key: :requestor_id, inverse_of: :requestor, autosave: true
  has_one :interpreter_detail, foreign_key: :interpreter_id, dependent: :destroy, inverse_of: :interpreter, autosave: true
  has_one :notification_setting, foreign_key: :user_id, dependent: :destroy, inverse_of: :user, autosave: true
  has_many :appointments, foreign_key: :interpreter_id
  has_many :requested_interpreters, foreign_key: "user_id"

  has_many :interpreter_specialties, dependent: :destroy, foreign_key: :interpreter_id
  has_many :specialties, through: :interpreter_specialties

  has_many :appointment_statuses, dependent: :destroy, foreign_key: :user_id

  has_many :pay_rate_interpreters, dependent: :destroy, foreign_key: :interpreter_id
  has_many :pay_rates, through: :pay_rate_interpreters

  has_many :availabilities, dependent: :destroy, foreign_key: :user_id
  has_many :time_offs, dependent: :destroy, foreign_key: :user_id
  has_many :checklist_items, dependent: :destroy, foreign_key: :user_id
  has_many :checklist_types, through: :checklist_items

  accepts_nested_attributes_for :interpreter_detail
  accepts_nested_attributes_for :requestor_detail
  accepts_nested_attributes_for :appointment_statuses
  accepts_nested_attributes_for :languages
  accepts_nested_attributes_for :interpreter_languages

  # We don't need users to confirm their email address on create,
  # just when they change it
  before_create :skip_confirmation!

  # Protect admin flag from editing
  attr_readonly :admin

  # Validations
  validates :name, presence: true
  validates :avatar, resizable_image: true

  # When ActionText rendering mentions in plain text
  def attachable_plain_text_representation(caption = nil)
    caption || name
  end

  def interpreter_detail_filled_out?
    interpreter_detail.present?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def is_interpreter?
    account_users.interpreter.any?
  end

  def is_agency_admin?
    account_users.agency_admin.any?
  end

  def is_requestor?
    account_users.site_admin.any?
  end

  # This field is used by the Noticed gem to send Twilio SMS messages
  def phone_number
    ph = notification_setting&.sms_number
    return nil if ph&.strip&.blank?

    ph = ph.delete("^0-9")

    # Add the Country Code (always 1 for US for now) for Twilio
    "1#{ph}"
  end

  def languages_list
    languages.map(&:name).join(", ")
  end

  def available_checklist_types(account)
    account.checklist_types.order("name ASC") - checklist_types.uniq
  end

  def send_interpreter_creation_mailer(agency)
    InterpreterCreationMailer.welcome(self, agency).deliver_later
  end
end
