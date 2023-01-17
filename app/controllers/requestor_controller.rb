class RequestorController < ApplicationController
  def index
    @requestor_accounts = AccountUser.where("roles->>'site_admin' = 'true'").or(AccountUser.where("roles->>'site_member' = 'true'")).or(AccountUser.where("roles->>'client' = 'true'"))
    @requestors_all = @requestor_accounts.joins(:user)
  end
end
