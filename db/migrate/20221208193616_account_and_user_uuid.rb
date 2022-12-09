class AccountAndUserUuid < ActiveRecord::Migration[7.0]
  # def change
  #   enable_extension "pgcrypto"

  #   add_column :users, :uuid, :uuid, default: "gen_random_uuid()", null: false
  #   add_column :accounts, :uuid, :uuid, default: "gen_random_uuid()", null: false

  #   # ------------------------------------------------------------
  #   # Users uuid

  #   add_column :api_tokens, :user_uuid, :uuid
  #   add_column :accounts, :owner_uuid, :uuid
  #   add_column :account_invitations, :invited_by_uuid, :uuid
  #   add_column :account_users, :user_uuid, :uuid
  #   add_column :appointments, :interpreter_uuid, :uuid
  #   add_column :interpreter_details, :interpreter_uuid, :uuid
  #   add_column :interpreter_languages, :interpreter_uuid, :uuid
  #   add_column :user_connected_accounts, :user_uuid, :uuid
  #   add_column :notification_tokens, :user_uuid, :uuid

  #   execute <<-SQL
  #     UPDATE api_tokens SET user_uuid = users.uuid
  #     FROM users WHERE api_tokens.user_id = users.id;

  #     UPDATE accounts SET owner_uuid = users.uuid
  #     FROM users WHERE accounts.owner_id = users.id;

  #     UPDATE account_invitations SET invited_by_uuid = users.uuid
  #     FROM users WHERE account_invitations.invited_by_id = users.id;

  #     UPDATE account_users SET user_uuid = users.uuid
  #     FROM users WHERE account_users.user_id = users.id;

  #     UPDATE appointments SET interpreter_uuid = users.uuid
  #     FROM users WHERE appointments.interpreter_id = users.id;

  #     UPDATE interpreter_details SET interpreter_uuid = users.uuid
  #     FROM users WHERE interpreter_details.interpreter_id = users.id;

  #     UPDATE interpreter_languages SET interpreter_uuid = users.uuid
  #     FROM users WHERE interpreter_languages.interpreter_id = users.id;

  #     UPDATE user_connected_accounts SET user_uuid = users.uuid
  #     FROM users WHERE user_connected_accounts.user_id = users.id;

  #     UPDATE notification_tokens SET user_uuid = users.uuid
  #     FROM users WHERE notification_tokens.user_id = users.id;
  #   SQL

  #   # change_column_null :api_tokens, :user_uuid, false
  #   # change_column_null :accounts, :owner_uuid, false
  #   # change_column_null :account_invitations, :invited_by_uuid, false
  #   # change_column_null :account_users, :user_uuid, false
  #   # change_column_null :appointments, :interpreter_uuid, false
  #   # change_column_null :interpreter_details, :interpreter_uuid, false
  #   # change_column_null :interpreter_languages, :interpreter_uuid, false
  #   # change_column_null :user_connected_accounts, :user_uuid, false
  #   # change_column_null :notification_tokens, :user_uuid, false

  #   remove_column :api_tokens, :user_id
  #   remove_column :accounts, :owner_id
  #   remove_column :account_invitations, :invited_by_id
  #   remove_column :account_users, :user_id
  #   remove_column :appointments, :interpreter_id
  #   remove_column :interpreter_details, :interpreter_id
  #   remove_column :interpreter_languages, :interpreter_id
  #   remove_column :user_connected_accounts, :user_id
  #   remove_column :notification_tokens, :user_id

  #   rename_column :api_tokens, :user_uuid, :user_id
  #   rename_column :accounts, :owner_uuid, :owner_id
  #   rename_column :account_invitations, :invited_by_uuid, :invited_by_id
  #   rename_column :account_users, :user_uuid, :user_id
  #   rename_column :appointments, :interpreter_uuid, :interpreter_id
  #   rename_column :interpreter_details, :interpreter_uuid, :interpreter_id
  #   rename_column :interpreter_languages, :interpreter_uuid, :interpreter_id
  #   rename_column :user_connected_accounts, :user_uuid, :user_id
  #   rename_column :notification_tokens, :user_uuid, :user_id

  #   add_index :api_tokens, :user_id
  #   add_index :accounts, :owner_id
  #   add_index :account_invitations, :invited_by_id
  #   add_index :account_users, :user_id
  #   add_index :appointments, :interpreter_id
  #   add_index :interpreter_details, :interpreter_id
  #   add_index :interpreter_languages, :interpreter_id
  #   add_index :user_connected_accounts, :user_id
  #   add_index :notification_tokens, :user_id

  #   # ------------------------------------------------------------
  #   # Accounts uuid

  #   add_column :account_invitations, :account_uuid, :uuid
  #   add_column :account_users, :account_uuid, :uuid
  #   add_column :appointments, :agency_uuid, :uuid
  #   add_column :appointments, :customer_uuid, :uuid
  #   add_column :sites, :customer_uuid, :uuid
  #   add_column :notifications, :account_uuid, :uuid
  #   add_column :rate_criteria, :account_uuid, :uuid

  #   execute <<-SQL
  #     UPDATE account_invitations SET account_uuid = accounts.uuid
  #     FROM accounts WHERE account_invitations.account_id = accounts.id;

  #     UPDATE account_users SET account_uuid = accounts.uuid
  #     FROM accounts WHERE account_users.account_id = accounts.id;

  #     UPDATE appointments SET agency_uuid = accounts.uuid
  #     FROM accounts WHERE appointments.agency_id = accounts.id;

  #     UPDATE appointments SET customer_uuid = accounts.uuid
  #     FROM accounts WHERE appointments.customer_id = accounts.id;

  #     UPDATE sites SET customer_uuid = accounts.uuid
  #     FROM accounts WHERE sites.customer_id = accounts.id;

  #     UPDATE notifications SET account_uuid = accounts.uuid
  #     FROM accounts WHERE notifications.account_id = accounts.id;

  #     UPDATE rate_criteria SET account_uuid = accounts.uuid
  #     FROM accounts WHERE rate_criteria.account_id = accounts.id;
  #   SQL

  #   # change_column_null :account_invitations, :account_uuid, false
  #   # change_column_null :account_users, :account_uuid, false
  #   # change_column_null :appointments, :agency_uuid, false
  #   # change_column_null :appointments, :customer_uuid, false
  #   # change_column_null :sites, :customer_uuid, false
  #   # change_column_null :notifications, :account_uuid, false
  #   # change_column_null :rate_criteria, :account_uuid, false

  #   remove_column :account_invitations, :account_id
  #   remove_column :account_users, :account_id
  #   remove_column :appointments, :agency_id
  #   remove_column :appointments, :customer_id
  #   remove_column :sites, :customer_id
  #   remove_column :notifications, :account_id
  #   remove_column :rate_criteria, :account_id

  #   rename_column :account_invitations, :account_uuid, :account_id
  #   rename_column :account_users, :account_uuid, :account_id
  #   rename_column :appointments, :agency_uuid, :agency_id
  #   rename_column :appointments, :customer_uuid, :customer_id
  #   rename_column :sites, :customer_uuid, :customer_id
  #   rename_column :notifications, :account_uuid, :account_id
  #   rename_column :rate_criteria, :account_uuid, :account_id

  #   add_index :account_invitations, :account_id
  #   add_index :account_users, :account_id
  #   add_index :appointments, :agency_id
  #   add_index :appointments, :customer_id
  #   add_index :sites, :customer_id
  #   add_index :notifications, :account_id
  #   add_index :rate_criteria, :account_id

  #   # ------------------------------

  #   remove_column :users, :id
  #   remove_column :accounts, :id
  #   rename_column :users, :uuid, :id
  #   rename_column :accounts, :uuid, :id
  #   execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  #   execute "ALTER TABLE accounts ADD PRIMARY KEY (id);"

  #   # add_index :users, :created_at
  #   # add_index :accounts, :created_at
  # end

  # def down
  #   raise ActiveRecord::IrreversibleMigration
  # end
end
