class Recipient < ApplicationRecord
  belongs_to :customer

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :recipients, partial: "recipients/index", locals: {recipient: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :recipients, target: dom_id(self, :index) }
end
