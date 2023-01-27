class RemoveAccountFromProviders < ActiveRecord::Migration[7.0]
  def change
    remove_reference :providers, :account, null: false, foreign_key: true

    add_reference :providers, :customer, null: false, foreign_key: {to_table: :accounts}, index: true, type: :uuid
  end
end
