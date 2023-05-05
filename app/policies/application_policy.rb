# frozen_string_literal: true

class ApplicationPolicy
  # We use AccountUser for policies because it contains roles for the current account
  # This allows separate roles for each user and account.
  #
  # Defaults:
  # - Allow admins
  # - Deny everyone else

  attr_reader :account_user, :record

  def initialize(account_user, record)
    # Comment out to allow guest users
    #raise Pundit::NotAuthorizedError, "must be logged in" unless account_user

    @account_user = account_user
    @record = record
  end

  def index?
    account_user.admin?
  end

  def show?
    account_user.admin?
  end

  def create?
    account_user.admin?
  end

  def new?
    create?
  end

  def update?
    account_user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    account_user.admin?
  end

  def show_billing?
    account_user&.admin?
  end

  class Scope
    def initialize(account_user, scope)
      # Comment out to allow guest users
      raise Pundit::NotAuthorizedError, "must be logged in" unless account_user

      @account_user = account_user
      @scope = scope
    end

    def resolve
      scope.all
    end

    # Check if account_user is an agency
    # To do this, we iterate through the AGENCY_ROLES_TO_SHOW const
    # and check each role on the account_user
    def is_agency?
      is_role_in_constant?(:AGENCY_ROLES_TO_SHOW)
    end

    # Same logic with `is_agency?`
    def is_customer?
      is_role_in_constant?(:CUSTOMER_ROLES)
    end

    # Check if account_user roles are in the specified role constant
    def is_role_in_constant?(account_user_role_constant)
      array = AccountUser.const_get(account_user_role_constant).map do |user_role|
        account_user.send(user_role)
      end

      array.compact.any? { |bool| bool == true }
    end

    private

    attr_reader :account_user, :scope
  end

  # Check if account_user is an agency
  # To do this, we iterate through the AGENCY_ROLES_TO_SHOW const
  # and check each role on the account_user
  def is_agency?
    is_role_in_constant?(:AGENCY_ROLES_TO_SHOW)
  end

  # Same logic with `is_agency?`
  def is_customer?
    is_role_in_constant?(:CUSTOMER_ROLES)
  end

  # Check if account_user roles are in the specified role constant
  def is_role_in_constant?(account_user_role_constant)
    array = AccountUser.const_get(account_user_role_constant).map do |user_role|
      account_user.send(user_role)
    end

    array.compact.any? { |bool| bool == true }
  end
end
