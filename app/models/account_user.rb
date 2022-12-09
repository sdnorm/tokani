# == Schema Information
#
# Table name: account_users
#
#  id         :bigint           not null, primary key
#  roles      :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#  account_id :uuid
#
# Indexes
#
#  index_account_users_on_account_id  (account_id)
#  index_account_users_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#

class AccountUser < ApplicationRecord
  # Add account roles to this line
  # Do NOT to use any reserved words like `user` or `account`
  ROLES = [
    :admin, # tokani admin user type
    :member, # tokani member user type
    :interpreter,
    :client, # individual or a site (from old app, requester/receiver)
    :agency_admin,
    :site_admin,
    :agency_member,
    :site_member
  ]

  TOKANI_ROLES = [
    :admin,
    :member,
    :agency_admin
  ].freeze

  AGENCY_ROLES = [
    :agency_admin,
    :site_admin,
    :interpreter,
    :agency_member
  ].freeze

  SITE_ROLES = [
    :site_admin,
    :site_member
  ].freeze

  include Rolified

  belongs_to :account
  belongs_to :user

  validates :user_id, uniqueness: {scope: :account_id}
  validate :owner_must_be_admin, on: :update, if: -> { admin_changed? && account_owner? }

  def account_owner?
    account.owner_id == user_id
  end

  def owner_must_be_admin
    unless admin?
      errors.add :admin, :cannot_be_removed
    end
  end
end
