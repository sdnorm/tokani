# Financial Report Service for fetching Financial Report appointments
class ReportService
  def initialize(report)
    @report = report
  end

  def fetch_appointments
    scope = Appointment

    scope = filter_by_account(scope)
    scope = filter_by_status(scope)
    scope = filter_by_date(scope)
    scope = filter_by_modality(scope)
    scope = filter_by_interpreter_type(scope)
    scope = filter_by_site(scope)
    scope = filter_by_department(scope)
    scope = filter_by_language(scope)
    scope = filter_by_customer(scope)
    filter_by_customer_category(scope)
  end

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

  def filter_by_customer(scope)
    return scope if @report.customers.empty?

    scope.joins(:customer)
      .where(customer: {id: @report.customers.collect(&:id)})
  end

  def filter_by_customer_category(scope)
    return scope if @report.customer_category_id.blank?

    # None of these scoped joins worked for me. Feel free to update this to use joins if you have time.

    # scope.joins(:customer).joins(customer: :customer_detail)
    #      .where(customer_details: {account_id: @report.account_id, id: @report.customer_category_id})

    # scope.joins("INNER JOIN customer_details ON customer_details.customer_id = appointment.customer_id")
    #      .merge( CustomerDetail.where(customer_category_id: @report.customer_category_id).joins("INNER JOIN customer_details ON customer_details.customer_id = appointments.customer_id") )

    # joins("INNER JOIN customer_details ON customer_details.customer_id = appointment.customer_id WHERE customer_details.customer_category_id = ?", @report.customer_category_id)

    # Instead we just duplicate the scope, iterate over it checking the deeply nested relation,
    # then add a scope of the matching IDs to the main scope that the method returns.
    duped_scope = scope.dup
    ids = []
    duped_scope.each do |appt|
      next unless appt.customer&.customer_detail&.customer_category_id == @report.customer_category_id

      ids << appt.id
    end

    scope.where(appointments: {id: ids})
  end
end
