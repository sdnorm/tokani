class AvailabilitiesController < ApplicationController
  include CurrentHelper

  before_action :set_interpreter
  before_action :check_interpreter_and_requestor_access

  def create
    if params[:times].blank?
      render status: :unprocessable_entity
      return false
    end
    @days = Date::DAYNAMES
    @availability = Availability.new(availability_params)
    @availability.set_times_from_hash(params[:times])

    if @availability.save
      # NK This new availability is JUST for a reset of the create form.  Not being saved
      @new_availability = @availability.interpreter.availabilities.build(wday: @availability.wday)
      @notice = "Availability created!"
      @availabilities = @availability.interpreter.availabilities.where(wday: @availability.wday)
    else
      render turbo_stream: turbo_stream.update("new_availability_notice", partial: "shared/error_messages", locals: {resource: @availability})
    end
  end

  def destroy
    @days = Date::DAYNAMES
    @availability = Availability.find(params[:id])
    @target = "#{@availability.id}_form_wrapper"
    @availability.destroy!
    @new_availability = @availability.interpreter.availabilities.build(wday: @availability.wday)
    @notice = "Availability removed!"
  end

  private

  def check_interpreter_and_requestor_access
    unless @interpreter.accounts.include?(current_account)
      return redirect_to(interpreter_dashboard_path, alert: "Access denied.")
    end

    unless @interpreter == current_user || current_user.is_a?(Requestor)
      redirect_to(interpreter_dashboard_path, alert: "Access denied.")
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_interpreter
    @interpreter = User.find(params[:availability][:interpreter_id])
  end

  def availability_params
    params.require(:availability).permit(:phone, :video, :in_person, :interpreter_id, :id, :wday, date: {})
  end
end
