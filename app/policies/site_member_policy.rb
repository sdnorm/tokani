class SiteMemberPolicy < ApplicationPolicy
  def show_side_nav? controller_name
    site_member? && blacklisted_controllers.exclude?(controller_name)
  end

  def access_to_interpreters?
    !site_member?
  end

  private

  # hide sidenav only from these controllers
  def blacklisted_controllers
    %w[
      registrations accounts subscriptions passwords
    ]
  end

  def site_member?
    @account_user.site_member? || @account_user.client?
  end
end
