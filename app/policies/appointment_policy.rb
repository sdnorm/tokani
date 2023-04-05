# frozen_string_literal: true

class AppointmentPolicy < ApplicationPolicy
  class AccountScope
    def initialize(account, scope)
      @account = account
      @scope = scope
    end

    def resolve
      if account.customer?
        scope.where(customer_id: account.id)
      else
        scope.where(agency_id: account.id)
      end
    end

    private

    attr_reader :account, :scope
  end

  def initialize(account, record, current_account_user)
    @account = account
    @record = record
    @current_account_user = current_account_user
  end

  attr_reader :account, :record, :current_account_user

  def show_appointments_statuses?
    account.customer? || current_account_user.interpreter?
  end

  def show_appointment_customers?
    account.agency?
  end
end
