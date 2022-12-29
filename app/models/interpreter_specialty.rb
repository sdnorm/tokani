# == Schema Information
#
# Table name: interpreter_specialties
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  interpreter_id :uuid             not null
#  specialty_id   :bigint           not null
#
# Indexes
#
#  index_interpreter_specialties_on_interpreter_id  (interpreter_id)
#  index_interpreter_specialties_on_specialty_id    (specialty_id)
#
# Foreign Keys
#
#  fk_rails_...  (specialty_id => specialties.id)
#
class InterpreterSpecialty < ApplicationRecord
  belongs_to :specialty
  belongs_to :interpreter

  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :interpreter_specialties, partial: "interpreter_specialties/index", locals: { interpreter_specialty: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :interpreter_specialties, target: dom_id(self, :index) }
end
