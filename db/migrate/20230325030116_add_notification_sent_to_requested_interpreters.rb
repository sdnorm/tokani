class AddNotificationSentToRequestedInterpreters < ActiveRecord::Migration[7.0]
  def change
    add_column :requested_interpreters, :notification_sent, :boolean, default: false
  end
end
