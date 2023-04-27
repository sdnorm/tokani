class AddLastRequestAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_request_at, :datetime
  end
end
