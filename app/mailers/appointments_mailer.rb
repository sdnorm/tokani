class AppointmentsMailer < ApplicationMailer
  include ApplicationHelper

  def appointment_created
    @account = params[:account]
    @appointment = params[:appointment]
    @recipient = params[:recipient]

    # We need this to support both User notifications and those just to an email address (Agency Emails)
    @to_email, @time_zone = *get_email_vars(@recipient, params)

    @subject = "New appointment created: #{appointment_info(@appointment, @time_zone)}"

    mail(
      to: @to_email,
      from: email_address_with_name(Jumpstart.config.support_email, FROM_NAME),
      subject: @subject
    )
  end

  def appointment_edited
    @account = params[:account]
    @appointment = params[:appointment]
    @recipient = params[:recipient]

    @to_email, @time_zone = *get_email_vars(@recipient, params)

    @subject = "Apointment edited: #{appointment_info(@appointment, @time_zone)}"

    mail(
      to: @to_email,
      from: email_address_with_name(Jumpstart.config.support_email, FROM_NAME),
      subject: @subject
    )
  end

  def appointment_cancelled
    @account = params[:account]
    @appointment = params[:appointment]
    @recipient = params[:recipient]

    @to_email, @time_zone = *get_email_vars(@recipient, params)

    @subject = "Apointment cancelled: #{appointment_info(@appointment, @time_zone)}"

    mail(
      to: @to_email,
      from: email_address_with_name(Jumpstart.config.support_email, FROM_NAME),
      subject: @subject
    )
  end

  def appointment_declined
    @account = params[:account]
    @appointment = params[:appointment]
    @recipient = params[:recipient]

    @to_email, @time_zone = *get_email_vars(@recipient, params)

    @subject = "Apointment declined: #{appointment_info(@appointment, @time_zone)}"

    mail(
      to: @to_email,
      from: email_address_with_name(Jumpstart.config.support_email, FROM_NAME),
      subject: @subject
    )
  end
end
