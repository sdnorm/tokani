class RecipientUuid < ActiveRecord::Migration[7.0]
  def change
    enable_extension "pgcrypto"

    add_column :recipients, :uuid, :uuid, default: "gen_random_uuid()", null: false

    remove_column :recipients, :id

    rename_column :recipients, :uuid, :id

    execute "ALTER TABLE recipients ADD PRIMARY KEY (id);"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
