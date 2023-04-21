class ChecklistItemsMailer < ApplicationMailer
  include ApplicationHelper

  def checklist_item_expiration
    @account = params[:account]
    @checklist_item = params[:checklist_item]
    @recipient = params[:recipient]

    @subject = "Checklist item expiration notice: #{@checklist_item.user.full_name} - #{@checklist_item.checklist_type.name}"

    mail(
      to: @recipient.email,
      from: email_address_with_name(Jumpstart.config.support_email, FROM_NAME),
      subject: @subject
    )
  end
end