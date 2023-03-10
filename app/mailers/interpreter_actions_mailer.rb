class InterpreterActionsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.interpreter_actions_mailer.interpreter_canceled.subject
  #
  def interpreter_canceled
    @account = params[:account]
    @appointment = params[:appointment]
    @interpreter = params[:interpreter]
    @recipient = params[:recipient]

    mail(
      to: email_address_with_name(@recipient.email, @recipient.full_name),
      from: email_address_with_name(Jumpstart.config.support_email, "Tokani Notifications"),
      subject: t(".subject", interpreter: @interpreter&.full_name, ref_number: @appointment&.ref_number)
    )
  end
end
