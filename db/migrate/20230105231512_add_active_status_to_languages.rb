class AddActiveStatusToLanguages < ActiveRecord::Migration[7.0]
  def change
    add_column :languages, :is_active, :boolean
  end
end
