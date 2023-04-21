class DashboardController < ApplicationController
  def show
    if current_account_user.nil?
      render template: "dashboard/general"
    elsif current_account_user.interpreter? # && current_user.interpreter_profile.nil?
      # redirect_to new_interpreter_detail_path
      redirect_to controller: :interpreters, action: :dashboard
    elsif current_account_user.customer_admin?
      grab_appointments_data_for_customer
      # render template: "dashboard/customer"
    elsif current_account_user.agency_admin? || current_account_user.agency_member?
      redirect_to agency_dashboard_path
    elsif current_user.admin?
      redirect_to agencies_path
    elsif current_account_user.site_admin? || current_account_user.site_member?
      grab_appointments_data_for_customer
      render template: "dashboard/requestor"
    else
      render template: "dashboard/requestor_details"
    end
  end

  def agency
    @agency = current_account
    if @agency.agency_detail.nil?
      redirect_to agency_detail_form_path
    else
      require_subscription!

      appointments = @agency.appointments
      @pagy, @appointments = pagy(appointments.sort_by_params(params[:sort], sort_direction))
    end
  end

  private

  def grab_appointments_data_for_customer
    @pagy, @appointments = pagy(Appointment.where(customer_id: current_account.id))
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end
end
