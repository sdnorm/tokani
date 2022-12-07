class ChangeUserIdToInterpreterIdOnInterpreterDetail < ActiveRecord::Migration[7.0]
  def change
    rename_column :interpreter_details, :user_id, :interpreter_id
  end
end
