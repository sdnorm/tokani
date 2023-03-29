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
    "Interpreter cancelled appointment: #{ref_number} - #{appointment.start_datetime_string_in_zone(time_zone)} - #{language} - #{customer}"
  end

  def time_zone
    recipient&.time_zone || appointment&.agency&.agency_detail&.time_zone || Account.time_zone_default
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
