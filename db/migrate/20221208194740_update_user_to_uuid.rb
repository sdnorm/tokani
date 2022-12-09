class UpdateUserToUuid < ActiveRecord::Migration[7.0]
  def change
    enable_extension "pgcrypto"

    add_column :users, :uuid, :uuid, default: "gen_random_uuid()"#, null: false

    add_column :api_tokens, :user_uuid, :uuid
    add_column :accounts, :owner_uuid, :uuid
    add_column :account_invitations, :invited_by_uuid, :uuid
    add_column :account_users, :user_uuid, :uuid
    add_column :appointments, :interpreter_uuid, :uuid
    add_column :interpreter_details, :interpreter_uuid, :uuid
    add_column :interpreter_languages, :interpreter_uuid, :uuid
    add_column :user_connected_accounts, :user_uuid, :uuid
    add_column :notification_tokens, :user_uuid, :uuid

    execute <<-SQL
      UPDATE api_tokens SET user_uuid = users.uuid
      FROM users WHERE api_tokens.user_id = users.id;

      UPDATE accounts SET owner_uuid = users.uuid
      FROM users WHERE accounts.owner_id = users.id;

      UPDATE account_invitations SET invited_by_uuid = users.uuid
      FROM users WHERE account_invitations.invited_by_id = users.id;

      UPDATE account_users SET user_uuid = users.uuid
      FROM users WHERE account_users.user_id = users.id;
      
      UPDATE appointments SET interpreter_uuid = users.uuid
      FROM users WHERE appointments.interpreter_id = users.id;

      UPDATE interpreter_details SET interpreter_uuid = users.uuid
      FROM users WHERE interpreter_details.interpreter_id = users.id;

      UPDATE interpreter_languages SET interpreter_uuid = users.uuid
      FROM users WHERE interpreter_languages.interpreter_id = users.id;

      UPDATE user_connected_accounts SET user_uuid = users.uuid
      FROM users WHERE user_connected_accounts.user_id = users.id;

      UPDATE notification_tokens SET user_uuid = users.uuid
      FROM users WHERE notification_tokens.user_id = users.id;
    SQL
  end
end
