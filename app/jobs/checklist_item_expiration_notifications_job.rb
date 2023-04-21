class ChecklistItemExpirationNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    ChecklistItem.where(notifications_sent: false).where("exp_date <= ?", 30.days.from_now.to_date).where("exp_date >= ?", Date.today).each do |checklist_item|

      # Send to Agency Admins
      checklist_item.user.accounts.each do |account|
        account.account_users.agency_admin.map(&:user).each do |admin|
          with_params = {account: account, checklist_item: checklist_item}
          ChecklistItemExpirationNotification.with(with_params).deliver_later(admin)
        end
      end

      # Send to Interpreter
      account = checklist_item.user.accounts.first
      with_params = {account: account, checklist_item: checklist_item}
      ChecklistItemExpirationNotification.with(with_params).deliver_later(checklist_item.user)

      checklist_item.update(notifications_sent: true)
    end
  end
end
