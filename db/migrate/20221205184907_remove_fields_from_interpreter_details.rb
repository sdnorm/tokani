class RemoveFieldsFromInterpreterDetails < ActiveRecord::Migration[7.0]
  def change
    remove_column :interpreter_details, :fname, :string
    remove_column :interpreter_details, :lname, :string
    remove_column :interpreter_details, :email, :string
  end
end
