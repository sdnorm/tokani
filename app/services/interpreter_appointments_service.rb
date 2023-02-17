# A service object for fetching interpreter appointments with various filters
class InterpreterAppointmentsService
  def initialize(user, params)
    @user = user
    @params = params
  end

  def fetch_appointments
    scope = Appointment

    scope = filter_by_status(scope)
    scope = filter_by_display_range(scope)
    scope = filter_by_modality(scope)
    order_by_start_time(scope)
  end

  private

  def filter_by_status(scope)
    return scope unless @params[:status].present?

    # We need to scope by custom queries depending on the status
    case @params[:status]
    when "offered"
      puts "\n\ngot here\n\n"
      scope.joins(:requested_interpreters)
        .where(requested_interpreters: {rejected: false, user_id: @user.id})
        .joins(:appointment_statuses)
        .where(appointment_statuses: {current: true, name: AppointmentStatus.names[@params[:status]]})
    when "scheduled"
      scope.where(interpreter_id: @user.id)
        .joins(:appointment_statuses)
        .where(appointment_statuses: {current: true, name: AppointmentStatus.names[@params[:status]]})
    else
      scope # Should never get here, but just in case
    end
  end

  def filter_by_display_range(scope)
    return scope unless @params[:display_range].present?

    case @params[:display_range]
    when "today"
      scope_by_today(scope)
    when "tomorrow"
      scope_by_tomorrow(scope)
    when "date_range"
      scope_by_date_range(scope)
    else
      scope
    end
  end

  def filter_by_modality(scope)
    return scope unless @params[:modality_in_person].present? || @params[:modality_phone].present? || @params[:modality_video].present?

    modalities = []

    if @params[:modality_in_person].present?
      modalities << Appointment.modalities["in_person"]
    end

    if @params[:modality_phone].present?
      modalities << Appointment.modalities["phone"]
    end

    if @params[:modality_video].present?
      modalities << Appointment.modalities["video"]
    end

    scope.where(modality: modalities)
  end

  def order_by_start_time(scope)
    scope.order(start_time: :asc)
  end

  def scope_by_today(scope)
    beginning_of_day = DateTime.now.in_time_zone(@user.time_zone).beginning_of_day
    end_of_day = DateTime.now.in_time_zone(@user.time_zone).end_of_day

    scope_by_range(scope, beginning_of_day, end_of_day)
  end

  def scope_by_tomorrow(scope)
    beginning_of_day = 1.day.from_now.in_time_zone(@user.time_zone).beginning_of_day
    end_of_day = 1.day.from_now.in_time_zone(@user.time_zone).end_of_day

    scope_by_range(scope, beginning_of_day, end_of_day)
  end

  def scope_by_date_range(scope)
    return scope unless @params[:start_date].present? && @params[:end_date].present?
    start_date = Date.parse(@params[:start_date])
    end_date = Date.parse(@params[:end_date])

    beginning_of_day = start_date.noon.in_time_zone(@user.time_zone).beginning_of_day
    end_of_day = end_date.noon.in_time_zone(@user.time_zone).end_of_day

    scope_by_range(scope, beginning_of_day, end_of_day)
  end

  def scope_by_range(scope, start_time, end_time)
    scope.where("appointments.start_time > ?", start_time.utc)
      .where("appointments.start_time < ?", end_time.utc)
  end
end
