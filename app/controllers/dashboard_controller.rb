class DashboardController < ApplicationController
  def show
    render_view_for(current_account_user)
  end

  def agency
    @agency = current_account
    if @agency.agency_detail.nil?
      redirect_to agency_detail_form_path
    else
      appointments = @agency.appointments
      @pagy, @appointments = pagy(appointments)
    end
  end

  private

  def render_view_for(user)
    case user_type(user)
    when :general
      render template: "dashboard/general"
    when :interpreter
      redirect_to controller: :interpreters, action: :dashboard
    when :customer_admin
      grab_appointments_data_for_customer
    when :agency_admin_or_member
      redirect_to agency_dashboard_path
    when :admin
      redirect_to agencies_path
    else
      render template: "dashboard/requestor_details"
    end
  end

  def user_type(user)
    return :general if user.nil?
    return :interpreter if user.interpreter?
    return :customer_admin if user.customer_admin?
    return :agency_admin_or_member if user.agency_admin? || user.agency_member?
    return :admin if user.admin?
  end

  def grab_appointments_data_for_customer
    @pagy, @appointments = pagy(Appointment.where(customer_id: current_account.id))
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end
end
