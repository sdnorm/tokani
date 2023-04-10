class ChecklistType < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :checklist_types, partial: "checklist_types/index", locals: {checklist_type: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :checklist_types, target: dom_id(self, :index) }

  enum format: {date: 1, boolean: 2, text: 3}

  validates :name, presence: {message: "Checklist Type name is required."}
end
