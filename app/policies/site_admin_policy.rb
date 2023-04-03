class SiteAdminPolicy < ApplicationPolicy
  def show_side_nav? controller_name
    site_admin? && blacklisted_controllers.exclude?(controller_name)
  end

  def access_to_interpreters?
    !site_admin?
  end

  private

  # hide sidenav only from these controllers
  def blacklisted_controllers
    %w[
      registrations accounts subscriptions passwords
    ]
  end

  def site_admin?
    @account_user.site_admin?
  end
end
