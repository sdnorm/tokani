# Service object for pulling data for the Interpreter Dashboard
class InterpreterDashboardService
  def initialize(user)
    @user = user
  end

  def appointment_stats_by_modality(modality)
    todays_count = stats_today(modality)
    weeks_count = stats_week(modality)
    months_count = stats_month(modality)

    {today: todays_count,
     week: weeks_count,
     month: months_count}
  end

  # Returns data formatted for a pie chart in an array like the following:
  # [["Assigned", 55], ["Accepted", 45]]
  def appointment_status_chart_data
    chart_data = []

    AppointmentStatus.names.keys.each do |status|
      count = monthly_count(status)
      next if count.zero?
      chart_data << [status.titleize, count]
    end

    chart_data
  end

  def upcoming_appointments
    beginning_of_day = DateTime.now.in_time_zone(@user.time_zone).beginning_of_day
    end_of_week = 7.days.from_now.in_time_zone(@user.time_zone).end_of_day

    Appointment.where(interpreter_id: @user.id)
      .where("appointments.start_time > ?", beginning_of_day.utc)
      .where("appointments.start_time < ?", end_of_week.utc)
      .joins(:appointment_statuses)
      .where(appointment_statuses: {current: true, name: AppointmentStatus.names["scheduled"]})
  end

  # Human-readable name of the current month (ex: "March")
  def current_month
    DateTime.now.in_time_zone(@user.time_zone).beginning_of_day.to_date.strftime("%B")
  end

  private

  def stats_today(modality)
    beginning_of_day = DateTime.now.in_time_zone(@user.time_zone).beginning_of_day
    end_of_day = DateTime.now.in_time_zone(@user.time_zone).end_of_day

    Appointment.where(interpreter_id: @user.id)
      .where("appointments.start_time > ?", beginning_of_day.utc)
      .where("appointments.start_time < ?", end_of_day.utc)
      .where(modality: Appointment.modalities[modality])
      .joins(:appointment_statuses)
      .where(appointment_statuses: {current: true, name: AppointmentStatus.names["scheduled"]}).count
  end

  def stats_week(modality)
    beginning_of_day = DateTime.now.in_time_zone(@user.time_zone).beginning_of_day
    end_of_week = 7.days.from_now.in_time_zone(@user.time_zone).end_of_day

    Appointment.where(interpreter_id: @user.id)
      .where("appointments.start_time > ?", beginning_of_day.utc)
      .where("appointments.start_time < ?", end_of_week.utc)
      .where(modality: Appointment.modalities[modality])
      .joins(:appointment_statuses)
      .where(appointment_statuses: {current: true, name: AppointmentStatus.names["scheduled"]}).count
  end

  def stats_month(modality)
    beginning_of_day = DateTime.now.in_time_zone(@user.time_zone).beginning_of_day
    end_of_month = 30.days.from_now.in_time_zone(@user.time_zone).end_of_day

    Appointment.where(interpreter_id: @user.id)
      .where("appointments.start_time > ?", beginning_of_day.utc)
      .where("appointments.start_time < ?", end_of_month.utc)
      .where(modality: Appointment.modalities[modality])
      .joins(:appointment_statuses)
      .where(appointment_statuses: {current: true, name: AppointmentStatus.names["scheduled"]}).count
  end

  # Returns a count of the interpreter's appointments for the current month (by status)
  def monthly_count(status)
    beginning_of_month = DateTime.now.in_time_zone(@user.time_zone).beginning_of_day.to_date.beginning_of_month
    end_of_month = DateTime.now.in_time_zone(@user.time_zone).beginning_of_day.to_date.end_of_month

    Appointment.where(interpreter_id: @user.id)
      .where("appointments.start_time > ?", beginning_of_month.to_datetime.beginning_of_day.utc)
      .where("appointments.start_time < ?", end_of_month.to_datetime.end_of_day.utc)
      .joins(:appointment_statuses)
      .where(appointment_statuses: {current: true, name: AppointmentStatus.names[status]}).count
  end
end
