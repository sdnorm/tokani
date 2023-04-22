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

  class AppointmentStatusesScope < Scope
    def initialize(account_user, scope)
      @account_user = account_user
      @scope = scope
    end

    def resolve
      # Only show cancel option
      if is_agency? || is_customer?
        # This should return :cancel
        scope::ACTIONS.slice(:cancel).keys
      end
    end

    attr_reader :account_user, :scope
  end

  def show_appointments_statuses?
    is_agency?
  end

  def show_appointment_customers?
    is_customer?
  end

  def cancel_appointment?
    is_agency? || is_customer?
  end
end
