class AddCustomerColumnsToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :contact_name, :string
    add_column :accounts, :email, :string
    add_column :accounts, :address, :string
    add_column :accounts, :city, :string
    add_column :accounts, :state, :string
    add_column :accounts, :zip, :string
    add_column :accounts, :is_active, :boolean, default: true
    add_column :accounts, :notes, :text
    add_column :accounts, :phone, :string
    add_column :accounts, :fax, :string
    add_column :accounts, :appointments_in_person, :boolean, default: true
    add_column :accounts, :appointments_video, :boolean, default: true
    add_column :accounts, :appointments_phone, :boolean, default: true
  end
end
