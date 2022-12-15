class SitesRateCriteriaUuid < ActiveRecord::Migration[7.0]
  def change
    enable_extension "pgcrypto"

    add_column :sites, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :rate_criteria, :uuid, :uuid, default: "gen_random_uuid()", null: false

    remove_column :sites, :id
    remove_column :rate_criteria, :id

    rename_column :sites, :uuid, :id
    rename_column :rate_criteria, :uuid, :id

    execute "ALTER TABLE sites ADD PRIMARY KEY (id);"
    execute "ALTER TABLE rate_criteria ADD PRIMARY KEY (id);"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
