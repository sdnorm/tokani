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
      if is_agency? || is_customer? || account_user.admin?
        scope::AGENCY_AND_CUSTOMER_ACTIONS
      else
        scope::DEFAULT_ACTIONS
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

  def cancel?
    @record.current_status&.in?(Workflows::AppointmentWorkflow::CANCELLABLE_STATUSES)
  end

  def my_scheduled_details?
    @record.interpreter_id == account_user.user_id
  end

  # Permit any user to open an appointment
  def open?
    account_user.present? && @record.current_status != "cancelled"
  end
end
