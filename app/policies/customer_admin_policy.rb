# frozen_string_literal: true

class CustomerAdminPolicy < ApplicationPolicy
  def show_side_nav? controller_name
    customer_admin? && blacklisted_controllers.exclude?(controller_name)
  end

  def access_to_interpreters?
    !customer_admin?
  end

  private

  # hide sidenav only from these controllers
  def blacklisted_controllers
    %w[
      registrations accounts subscriptions passwords notification_settings
    ]
  end

  def customer_admin?
    @account_user.customer_admin?
  end
end
