class RemoveNotNullRequirementFromInterpreterDetailsAgain < ActiveRecord::Migration[7.0]
  def change
    change_column_null :interpreter_details, :user_id, true
  end
end
