# frozen_string_literal: true

class AgencyAdminPolicy < ApplicationPolicy
  def show_side_nav? controller_name
    agency_admin? && blacklisted_controllers.exclude?(controller_name)
  end

  private

  # hide sidenav only from these controllers
  def blacklisted_controllers
    %w[
      registrations accounts subscriptions passwords notification_settings agency_details agencies account_invitations account_users
    ]
  end

  def agency_admin?
    @account_user.agency_admin?
  end
end
