class ReportService
  def initialize(report)
    @report = report
  end

  def fetch_appointments
    scope = Appointment

    scope = filter_by_status(scope)
    scope = filter_by_date(scope)
    scope = filter_by_modality(scope)
    scope = filter_by_interpreter_type(scope)
    scope = filter_by_site(scope)
    scope = filter_by_department(scope)
    scope = filter_by_language(scope)
    filter_by_agency_customer(scope)
  end

  def filter_by_status(scope)
    scope.where(status: Appointment.statuses["exported"])
  end

  def filter_by_date(scope)
    return scope unless @report.date_begin.present? && @report.date_end.present?

    scope.where("appointments.start_time > ?", @report.date_begin.beginning_of_day)
      .where("appointments.start_time < ?", @report.date_end.end_of_day)
  end

  def filter_by_modality(scope)
    scope.where(modality: @report.modalities)
  end

  def filter_by_interpreter_type(scope)
    return scope if @report.interpreter_type.blank?

    scope.joins(:interpreter)
      .where(interpreter: {interpreter_type: @report.interpreter_type})
  end

  def filter_by_site(scope)
    return scope if @report.site_id.blank?

    scope.joins(:site)
      .where(site: {id: @report.site_id})
  end

  def filter_by_department(scope)
    return scope if @report.department_id.blank?

    scope.joins(:department)
      .where(department: {id: @report.department_id})
  end

  def filter_by_language(scope)
    return scope if @report.language_id.blank?

    scope.where(language_id: @report.language_id)
  end

  def filter_by_agency_customer(scope)
    return scope if @report.agency_customers.empty?

    scope.joins(:agency_customer)
      .where(agency_customer: {id: @report.agency_customers.collect(&:id)})
  end
end