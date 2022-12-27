class RemoveCustomerColumnsFromAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :contact_name, :string
    remove_column :accounts, :email, :string
    remove_column :accounts, :address, :string
    remove_column :accounts, :city, :string
    remove_column :accounts, :state, :string
    remove_column :accounts, :zip, :string
    remove_column :accounts, :notes, :text
    remove_column :accounts, :phone, :string
    remove_column :accounts, :fax, :string
    remove_column :accounts, :appointments_in_person, :boolean
    remove_column :accounts, :appointments_video, :boolean
    remove_column :accounts, :appointments_phone, :boolean
  end
end
