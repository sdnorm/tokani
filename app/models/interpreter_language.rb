# == Schema Information
#
# Table name: interpreter_languages
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  interpreter_id :uuid
#  language_id    :bigint           not null
#
# Indexes
#
#  index_interpreter_languages_on_interpreter_id  (interpreter_id)
#  index_interpreter_languages_on_language_id     (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
class InterpreterLanguage < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :interpreter_languages, partial: "interpreter_languages/index", locals: {interpreter_language: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :interpreter_languages, target: dom_id(self, :index) }

  belongs_to :language
  belongs_to :interpreter, class_name: "User"
end
