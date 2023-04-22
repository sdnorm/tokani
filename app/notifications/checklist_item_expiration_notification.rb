class ChecklistItemExpirationNotification < ApplicationNotification
  deliver_by :action_cable, format: :to_websocket, channel: "NotificationChannel"
  deliver_by :email, mailer: "ChecklistItemsMailer", method: :checklist_item_expiration, if: :email_notifications?
  deliver_by :twilio, if: :sms_notifications?

  param :account
  param :checklist_item

  def to_websocket
    {
      account_id: record.account_id,
      html: ApplicationController.render(partial: "notifications/notification", locals: {notification: record})
    }
  end

  def message
    "Checklist item expiration notice: #{full_name} - #{checklist_type}"
  end

  def checklist_item
    params[:checklist_item]
  end

  def full_name
    checklist_item.user.full_name
  end

  def checklist_type
    checklist_item.checklist_type.name
  end

  def url
    checklist_item_path(checklist_item)
  end

  def email_notifications?
    recipient&.notification_setting&.checklist_item_expiration
  end
end
