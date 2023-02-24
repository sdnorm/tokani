class AddTokaniAdminFieldToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :tokani_admin, :boolean
  end
end
