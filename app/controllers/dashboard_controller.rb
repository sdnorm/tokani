class DashboardController < ApplicationController
  def show
    if current_account_user.interpreter? # && current_user.interpreter_profile.nil?
      redirect_to new_interpreter_detail_path
    end
  end
end
