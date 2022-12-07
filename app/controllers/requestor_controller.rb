class RequestorController < ApplicationController
  def index
    @requestor_accounts = AccountUser.where("roles->>'site_admin' = 'true'").or(AccountUser.where("roles->>'agency_admin' = 'true'"))
    @requestors_all = @requestor_accounts.joins(:user)
  end
end
