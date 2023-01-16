class InterpreterController < ApplicationController
  include CurrentHelper

  before_action :authenticate_user!

  def index
    # # current_account_id = current_account.id
    # @interpreter_account_ids = AccountUser.where(roles: {interpreter: true}).where(account_id: current_account.id).pluck(:user_id)
    # # @interpreter_account_ids = AccountUser.where("roles->>'interpreter' = 'true'").where(account_id: current_account_id).pluck(:user_id)
    # @interpreters_all = User.includes(:interpreter_detail).where(id: @interpreter_account_ids)
    @pagy, @interpreters = pagy(User.where(id: current_account.account_users.interpreter.pluck(:user_id)).sort_by_params(params[:sort], sort_direction))
  end
end
