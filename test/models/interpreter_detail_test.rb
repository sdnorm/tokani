# == Schema Information
#
# Table name: interpreter_details
#
#  id                      :bigint           not null, primary key
#  address                 :string
#  city                    :string
#  dob                     :date
#  drivers_license         :string
#  emergency_contact_name  :string
#  emergency_contact_phone :string
#  gender                  :integer
#  interpreter_type        :integer
#  primary_phone           :string
#  ssn                     :string
#  start_date              :date
#  state                   :string
#  time_zone               :string
#  zip                     :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  interpreter_id          :uuid
#
# Indexes
#
#  index_interpreter_details_on_interpreter_id  (interpreter_id)
#
require "test_helper"

class InterpreterDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
