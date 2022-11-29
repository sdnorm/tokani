class RemoveNotNullRequirementFromInterpreterDetails < ActiveRecord::Migration[7.0]
  def change
    change_column_null :interpreter_details, :user_id, false
  end
end
