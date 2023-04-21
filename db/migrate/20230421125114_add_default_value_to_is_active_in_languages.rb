class AddDefaultValueToIsActiveInLanguages < ActiveRecord::Migration[7.0]
  def up
    change_column :languages, :is_active, :boolean, default: true
  end

  def down
    change_column :languages, :is_active, :boolean, default: nil
  end
end
