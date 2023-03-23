class InterpreterCanceledNotification < ApplicationNotification
  deliver_by :action_cable, format: :to_websocket, channel: "NotificationChannel"
  deliver_by :email, mailer: "InterpreterActionsMailer", method: :interpreter_canceled, if: :email_notifications?
  deliver_by :twilio, if: :sms_notifications?

  param :account
  param :interpreter
  param :appointment

  def to_websocket
    {
      account_id: record.account_id,
      html: ApplicationController.render(partial: "notifications/notification", locals: {notification: record})
    }
  end

  def message
    t "notifications.interpreter_canceled", interpreter: interpreter_name, ref_number: ref_number, status: status
  end

  def url
    appointment_path(params[:appointment])
  end

  def interpreter_name
    params[:interpreter]&.full_name
  end

  def status
    params[:appointment]&.status&.titleize
  end

  def ref_number
    params[:appointment]&.ref_number
  end

  def email_notifications?
    recipient&.notification_setting&.interpreter_cancelled
  end
end
