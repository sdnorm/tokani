class InterpreterDetailPolicy < ApplicationPolicy
  # https://github.com/varvet/pundit
  # See ApplicationPolicy for defaults

  def show?
    is_admin_or_interpreter?
  end

  def edit?
    is_admin_or_interpreter?
  end

  def new?
    is_admin_or_interpreter?
  end

  def create?
    is_admin_or_interpreter?
  end

  def update?
    is_admin_or_interpreter?
  end

  def destroy?
    is_admin_or_interpreter?
  end

  def update_languages?
    is_admin_or_interpreter?
  end

  private

  def is_admin_or_interpreter?
    account_user.admin? || account_user.interpreter?
  end
end
