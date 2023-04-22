class AddChecklistItemExpirationToNotificationSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :notification_settings, :checklist_item_expiration, :boolean, default: true
  end
end
