class AddNotificationsSentToChecklistItems < ActiveRecord::Migration[7.0]
  def change
    add_column :checklist_items, :notifications_sent, :boolean, default: false
  end
end
