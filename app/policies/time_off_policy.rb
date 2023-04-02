class TimeOffPolicy < ApplicationPolicy
  # https://github.com/varvet/pundit
  # See ApplicationPolicy for defaults

  class Scope < Scope
    def resolve
      if account_user.admin?
        scope.all
      else
        scope.where(user_id: account_user.user_id)
      end
    end
  end

  def index?
    is_admin_or_interpreter?
  end

  def new?
    is_admin_or_interpreter?
  end

  def create?
    is_admin_or_interpreter?
  end

  def destroy?
    is_admin_or_interpreter?
  end

  private

  def is_admin_or_interpreter?
    account_user.admin? || account_user.interpreter?
  end
end
