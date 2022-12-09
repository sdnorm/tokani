class AddIndexesRedoUserIdColumnAndResetPrimaryKeyOnUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :api_tokens, :user_id
    add_index :accounts, :owner_id
    add_index :account_invitations, :invited_by_id
    add_index :account_users, :user_id
    add_index :appointments, :interpreter_id
    add_index :interpreter_details, :interpreter_id
    add_index :interpreter_languages, :interpreter_id
    add_index :user_connected_accounts, :user_id
    add_index :notification_tokens, :user_id

    remove_column :users, :id

    rename_column :users, :uuid, :id

    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  end
end
