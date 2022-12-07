class InterpreterController < ApplicationController
  include CurrentHelper

  def index
    current_account_id = current_account.id
    @interpreter_account_ids = AccountUser.where("roles->>'interpreter' = 'true'").where(account_id: current_account_id).pluck(:user_id)
    @interpreters_all = InterpreterDetail.joins(:user).where(user_id: @interpreter_account_ids)
  end
end
