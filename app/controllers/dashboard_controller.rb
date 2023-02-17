class DashboardController < ApplicationController
  def show
    if current_account_user.interpreter? # && current_user.interpreter_profile.nil?
      # redirect_to new_interpreter_detail_path
      render template: "dashboard/interpreter"
    elsif current_account_user.agency_admin?
      render template: "dashboard/agency_admin"
    elsif current_account_user.admin?
      redirect_to agencies_path
      # render template: "agencies/index"
    else
      render template: "dashboard/requestor_details"
    end
  end
end
