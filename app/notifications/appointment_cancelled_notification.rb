class AppointmentCancelledNotification < ApplicationNotification
  deliver_by :action_cable, format: :to_websocket, channel: "NotificationChannel"
  deliver_by :email, mailer: "AppointmentsMailer", method: :appointment_cancelled, if: :email_notifications?
  deliver_by :twilio, if: :sms_notifications?

  param :account
  param :appointment

  def to_websocket
    {
      account_id: record.account_id,
      html: ApplicationController.render(partial: "notifications/notification", locals: {notification: record})
    }
  end

  def message
    "Appopintment cancelled: #{ref_number} - #{appointment.start_datetime_string_in_zone(time_zone)} - #{language} - #{customer}"
  end

  def time_zone
    recipient&.time_zone || appointment&.agency&.agency_detail&.time_zone || Account.time_zone_default
  end

  def appointment
    params[:appointment]
  end

  def url
    appointment_path(appointment)
  end

  def ref_number
    appointment&.ref_number
  end

  def language
    appointment&.language&.name
  end

  def customer
    appointment&.customer&.name
  end

  def email_notifications?
    recipient&.notification_setting&.appointment_cancelled
  end
end
