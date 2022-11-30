# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Language < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :languages, partial: "languages/index", locals: {language: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :languages, target: dom_id(self, :index) }

  has_many :appointment_languages, dependent: :destroy
  has_many :interpreter_languages, dependent: :destroy
end
