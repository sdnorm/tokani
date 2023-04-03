class DeliverAppointmentReminderNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    Appointment.where(interpreter_reminder_sent: false).where("start_time < ?", 24.hours.from_now.utc).where("start_time > ?", DateTime.now.utc).each do |appointment|
      next unless appointment&.interpreter.present?
      with_params = {account: appointment&.agency, appointment: appointment}
      AppointmentReminderNotification.with(with_params).deliver_later(appointment.interpreter)
      appointment.update(interpreter_reminder_sent: true)
    end
  end
end
