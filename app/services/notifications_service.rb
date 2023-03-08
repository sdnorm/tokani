# A service object wrapper to handle details like which recipients to send a notification to, etc.
class NotificationsService
  # These are all class methods. Usage example:
  #
  # NotificationsService.deliver_interpreter_canceled_notification(account: current_account, interpreter: current_user, appointment: appointment)
  #
  class << self
    def deliver_interpreter_canceled_notification(with_params = {})
      account = with_params[:account]
      appointment = with_params[:appointment]
      recipients = []
      recipients << account.owner # Always include the owner
      recipients << appointment.creator # and the Appointment creator
      recipients << appointment.requestor # .. and the requestor

      recipients.compact.each do |recipient|
        InterpreterCanceledNotification.with(with_params).deliver_later(recipient)
      end
    end
  end
end
