class AddEmailToInterpreterDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :interpreter_details, :email, :string
  end
end
