# Fill Rate Report Service for fetching Fill Rate Report appointments
class FillRateReportService
  def initialize(report)
    @report = report
  end

  def appointments
    return @appointments if @appointments.present?
    @appointments = fetch_appointments
  end

  def fetch_appointments
    scope = Appointment

    scope = filter_by_account(scope)
    scope = filter_by_status(scope)
    scope = filter_by_date(scope)
    scope = filter_by_customer(scope)
    scope = filter_by_interpreter(scope)
    filter_by_language(scope)
  end

  # Appointment Scope Filters

  def filter_by_account(scope)
    scope.where(agency_id: @report.account_id)
  end

  def filter_by_status(scope)
    scope.joins(:appointment_statuses)
      .where(appointment_statuses: {current: true, name: AppointmentStatus.names["exported"]})
  end

  def filter_by_date(scope)
    return scope unless @report.date_begin.present? && @report.date_end.present?

    scope.where("appointments.start_time > ?", @report.date_begin.beginning_of_day)
      .where("appointments.start_time < ?", @report.date_end.end_of_day)
  end

  def filter_by_customer(scope)
    return scope if @report.customer_id.blank?

    scope.joins(:customer)
      .where(customer: {id: @report.customer_id})
  end

  def filter_by_interpreter(scope)
    return scope if @report.interpreter_id.blank?

    scope.where(interpreter_id: @report.interpreter_id)
  end

  def filter_by_language(scope)
    return scope if @report.language_id.blank?

    scope.where(language_id: @report.language_id)
  end

  # / Appointment Scope Filters

  # Aggregate methods for the report

  def total
    appointments.count
  end

  def cancels_total
    fetch_appointments.where(cancel_type: "requestor").count
  end

  def net_requests
    total - cancels_total
  end

  def filled_total
    fetch_appointments.count { |a| ((a.cancel_type != "requestor") && a.interpreter_id.present?) }
  end

  def not_filled_total
    fetch_appointments.count { |a| ((a.cancel_type != "requestor") && a.interpreter_id.blank?) }
  end

  def percentage_filled
    (filled_total / net_requests) * 100
  end

  # / Aggregate methods for the report
end
