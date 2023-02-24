class DashboardController < ApplicationController
  def show
    if current_account_user.nil?
      render template: "dashboard/general"
    elsif current_account_user.interpreter? # && current_user.interpreter_profile.nil?
      # redirect_to new_interpreter_detail_path
      render template: "dashboard/interpreter"
    elsif current_account_user.agency_admin? || current_account_user.agency_member?
      appointments = current_account.appointments
      @pagy, @appointments = pagy(appointments)   
      redirect_to agency_dashboard_path
    elsif current_account_user.admin?
      redirect_to agencies_path
      # render template: "agencies/index"
    else
      render template: "dashboard/requestor_details"
    end
  end

  def agency
    appointments = current_account.appointments
    @pagy, @appointments = pagy(appointments)    
  end
end
