# A service object wrapper to handle details like which recipients to send a notification to, etc.
class NotificationsService
  # These are all class methods. Usage example:
  #
  # NotificationsService.deliver_interpreter_cancelled_notifications(account: current_account, interpreter: current_user, appointment: appointment)
  #
  class << self
    def deliver_interpreter_cancelled_notifications(with_params = {})
      account = with_params[:account]
      appointment = with_params[:appointment]
      recipients = []

      # Include all Agency Admins
      account.account_users.agency_admin.each do |user_acc|
        user = user_acc&.user
        recipients << user
      end

      recipients << appointment.creator # and the Appointment creator
      recipients << appointment.requestor # .. and the requestor

      recipients.compact.uniq.each do |recipient|
        InterpreterCanceledNotification.with(with_params).deliver_later(recipient)
      end
    end

    def deliver_appointment_created_notifications(with_params = {})
      account = with_params[:account]
      appointment = with_params[:appointment]
      recipients = []

      # Send to all Agency Admins
      account.account_users.agency_admin.each do |admin|
        recipients << admin&.user
      end

      recipients << appointment.creator
      recipients << appointment.requestor

      recipients.compact.uniq.each do |recipient|
        AppointmentCreatedNotification.with(with_params).deliver_later(recipient)
      end

      if account&.notification_email&.appointment_created
        emails = []
        emails << account&.notification_email&.email1 if account&.notification_email&.email1&.present?
        emails << account&.notification_email&.email2 if account&.notification_email&.email2&.present?

        emails.compact.each do |email|
          with_params[:email] = email
          AppointmentsMailer.with(with_params).appointment_created.deliver_later
        end
      end
    end

    def deliver_appointment_edited_notifications(with_params = {})
      account = with_params[:account]
      appointment = with_params[:appointment]
      recipients = []

      # Send to all Agency Admins
      account.account_users.agency_admin.each do |admin|
        recipients << admin&.user
      end

      recipients << appointment.creator
      recipients << appointment.requestor

      recipients.compact.uniq.each do |recipient|
        AppointmentEditedNotification.with(with_params).deliver_later(recipient)
      end

      if account&.notification_email&.appointment_edited
        emails = []
        emails << account&.notification_email&.email1 if account&.notification_email&.email1&.present?
        emails << account&.notification_email&.email2 if account&.notification_email&.email2&.present?

        emails.compact.each do |email|
          with_params[:email] = email
          AppointmentsMailer.with(with_params).appointment_edited.deliver_later
        end
      end
    end

    def deliver_appointment_cancelled_notifications(with_params = {})
      account = with_params[:account]
      appointment = with_params[:appointment]
      recipients = []

      # Send to all Agency Admins
      account.account_users.agency_admin.each do |admin|
        recipients << admin&.user
      end

      recipients << appointment.creator
      recipients << appointment.requestor
      recipients << appointment.interpreter

      recipients.compact.uniq.each do |recipient|
        AppointmentCancelledNotification.with(with_params).deliver_later(recipient)
      end

      if account&.notification_email&.appointment_cancelled
        emails = []
        emails << account&.notification_email&.email1 if account&.notification_email&.email1&.present?
        emails << account&.notification_email&.email2 if account&.notification_email&.email2&.present?

        emails.compact.each do |email|
          with_params[:email] = email
          AppointmentsMailer.with(with_params).appointment_cancelled.deliver_later
        end
      end
    end

    def deliver_appointment_declined_notifications(with_params = {})
      account = with_params[:account]
      appointment = with_params[:appointment]
      recipients = []

      # Send to all Agency Admins
      account.account_users.agency_admin.each do |admin|
        recipients << admin&.user
      end

      recipients << appointment.creator
      recipients << appointment.requestor
      recipients << appointment.interpreter

      recipients.compact.uniq.each do |recipient|
        AppointmentDeclinedNotification.with(with_params).deliver_later(recipient)
      end

      if account&.notification_email&.appointment_declined
        emails = []
        emails << account&.notification_email&.email1 if account&.notification_email&.email1&.present?
        emails << account&.notification_email&.email2 if account&.notification_email&.email2&.present?

        emails.compact.each do |email|
          with_params[:email] = email
          AppointmentsMailer.with(with_params).appointment_declined.deliver_now
        end
      end
    end

    def deliver_appointment_offered_notifications(with_params = {})
      appointment = with_params[:appointment]
      recipients = []

      appointment.requested_interpreters.unsent_notifications.each do |ri|
        recipients << ri&.interpreter
        ri.update(notification_sent: true)
      end

      recipients.compact.uniq.each do |recipient|
        AppointmentOfferedNotification.with(with_params).deliver_later(recipient)
      end
    end

    def deliver_appointment_reminder_notifications
      Appointment.where(interpreter_reminder_sent: false).where("start_time < ?", 24.hours.from_now.utc).where("start_time > ?", DateTime.now.utc).each do |appointment|
        next unless appointment&.interpreter.present?
        with_params = {account: appointment&.agency, appointment: appointment}
        AppointmentReminderNotification.with(with_params).deliver_later(appointment&.interpreter)
        appointment.update(interpreter_reminder_sent: true)
      end
    end
  end
end
