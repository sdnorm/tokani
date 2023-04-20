class AddViewableByToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :viewable_by, :integer
  end
end
