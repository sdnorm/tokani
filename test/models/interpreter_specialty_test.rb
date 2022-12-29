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
require "test_helper"

class InterpreterSpecialtyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
