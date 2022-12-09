class RenameAssociatedColumnNamesForUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :api_tokens, :user_id
    remove_column :accounts, :owner_id
    remove_column :account_invitations, :invited_by_id
    remove_column :account_users, :user_id
    remove_column :appointments, :interpreter_id
    remove_column :interpreter_details, :interpreter_id
    remove_column :interpreter_languages, :interpreter_id
    remove_column :user_connected_accounts, :user_id
    remove_column :notification_tokens, :user_id

    rename_column :api_tokens, :user_uuid, :user_id
    rename_column :accounts, :owner_uuid, :owner_id
    rename_column :account_invitations, :invited_by_uuid, :invited_by_id
    rename_column :account_users, :user_uuid, :user_id
    rename_column :appointments, :interpreter_uuid, :interpreter_id
    rename_column :interpreter_details, :interpreter_uuid, :interpreter_id
    rename_column :interpreter_languages, :interpreter_uuid, :interpreter_id
    rename_column :user_connected_accounts, :user_uuid, :user_id
    rename_column :notification_tokens, :user_uuid, :user_id
  end
end
