class DashboardController < ApplicationController
  def show
    if current_account_user.interpreter? # && current_user.interpreter_profile.nil?
      redirect_to new_interpreter_detail_path
    elsif current_account_user.agency_admin?
      render "dashboard/agency_admin"
    elsif current_account_user.agency_admin?
      render "agency/index"
    else
      render "dashboard/requestor_details"
    end
    redirect_to agencies_path
  end
  # <% elsif current_account_user.admin? %>
  #   <%= render partial: "tokani_admin" %>
  # <% else %>
end
