# A service object for fetching interpreter appointments with various filters
class InterpreterAppointmentsService
  include ActionController::Helpers
  include Sortable

  def initialize(user, params, current_account = nil)
    @user = user
    @params = params
    @account = current_account
  end

  attr_accessor :params

  def fetch_appointments
    scope = if @account.nil?
      Appointment.all
    else
      @account.appointments
    end

    scope = filter_by_status(scope)
    scope = filter_by_display_range(scope)
    scope = filter_by_modality(scope)
    scope = scope_by_date_range(scope)
    filter_by_search_query(scope)
  end

  private

  def filter_by_status(scope)
    return scope unless @params[:status].present?

    # We need to scope by custom queries depending on the status
    case @params[:status]
    when "all"
      scope.unscoped
    when "processed"
      # Special scope to show just several appointment status types
      processed_statuses = ["finished", "verified", "exported"]
      scope.by_appointment_specific_status(processed_statuses)
    else
      scope.by_appointment_specific_status(@params[:status])
    end
  end

  def filter_by_display_range(scope)
    return scope unless @params[:display_range].present?

    case @params[:display_range]
    when "today"
      scope_by_today(scope)
    when "tomorrow"
      scope_by_tomorrow(scope)
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

  def filter_by_search_query(scope)
    return scope unless @params[:search_query].present?
    query = @params[:search_query]
    query = "%#{query}%"

    scope.includes(:customer, :site)
      .references(:account, :site)
      .where(
        "appointments.ref_number ILIKE ? OR accounts.name ILIKE ? OR sites.name ILIKE ?",
        query, query, query
      )
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
