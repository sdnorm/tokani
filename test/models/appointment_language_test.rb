# == Schema Information
#
# Table name: appointment_languages
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :bigint           not null
#  language_id    :bigint           not null
#
# Indexes
#
#  index_appointment_languages_on_appointment_id  (appointment_id)
#  index_appointment_languages_on_language_id     (language_id)
#
require "test_helper"

class AppointmentLanguageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
