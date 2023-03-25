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

  def initialize(account, record)
    @account = account
    @record = record
  end

  attr_reader :account, :record

  def show_appointments_statuses?
    account.customer?
  end

  def show_appointment_customers?
    account.agency?
  end
end
