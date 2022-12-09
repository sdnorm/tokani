class AccountUuid < ActiveRecord::Migration[7.0]
  def change
    enable_extension "pgcrypto"

    add_column :accounts, :uuid, :uuid, default: "gen_random_uuid()", null: false

    add_column :account_invitations, :account_uuid, :uuid
    add_column :account_users, :account_uuid, :uuid
    add_column :appointments, :agency_uuid, :uuid
    add_column :appointments, :customer_uuid, :uuid
    add_column :sites, :customer_uuid, :uuid
    add_column :notifications, :account_uuid, :uuid
    add_column :rate_criteria, :account_uuid, :uuid
    add_column :addresses, :addressable_uuid, :uuid

    execute <<-SQL
      UPDATE account_invitations SET account_uuid = accounts.uuid
      FROM accounts WHERE account_invitations.account_id = accounts.id;

      UPDATE account_users SET account_uuid = accounts.uuid
      FROM accounts WHERE account_users.account_id = accounts.id;

      UPDATE appointments SET agency_uuid = accounts.uuid
      FROM accounts WHERE appointments.agency_id = accounts.id;

      UPDATE appointments SET customer_uuid = accounts.uuid
      FROM accounts WHERE appointments.customer_id = accounts.id;

      UPDATE sites SET customer_uuid = accounts.uuid
      FROM accounts WHERE sites.customer_id = accounts.id;

      UPDATE notifications SET account_uuid = accounts.uuid
      FROM accounts WHERE notifications.account_id = accounts.id;

      UPDATE rate_criteria SET account_uuid = accounts.uuid
      FROM accounts WHERE rate_criteria.account_id = accounts.id;

      UPDATE addresses SET addressable_uuid = accounts.uuid
      FROM accounts WHERE addresses.addressable_id = accounts.id;
    SQL

    change_column_null :account_invitations, :account_uuid, false
    change_column_null :sites, :customer_uuid, false
    change_column_null :notifications, :account_uuid, false
    change_column_null :addresses, :addressable_uuid, false

    remove_column :account_invitations, :account_id
    remove_column :account_users, :account_id
    remove_column :appointments, :agency_id
    remove_column :appointments, :customer_id
    remove_column :sites, :customer_id
    remove_column :notifications, :account_id
    remove_column :rate_criteria, :account_id
    remove_column :addresses, :addressable_id

    rename_column :account_invitations, :account_uuid, :account_id
    rename_column :account_users, :account_uuid, :account_id
    rename_column :appointments, :agency_uuid, :agency_id
    rename_column :appointments, :customer_uuid, :customer_id
    rename_column :sites, :customer_uuid, :customer_id
    rename_column :notifications, :account_uuid, :account_id
    rename_column :rate_criteria, :account_uuid, :account_id
    rename_column :addresses, :addressable_uuid, :addressable_id

    add_index :account_invitations, :account_id
    add_index :account_users, :account_id
    add_index :appointments, :agency_id
    add_index :appointments, :customer_id
    add_index :sites, :customer_id
    add_index :notifications, :account_id
    add_index :rate_criteria, :account_id

    # ------------------------------

    remove_column :accounts, :id
    rename_column :accounts, :uuid, :id
    execute "ALTER TABLE accounts ADD PRIMARY KEY (id);"

    add_index :accounts, :created_at
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
