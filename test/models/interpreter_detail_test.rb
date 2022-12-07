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
#  zip                     :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :bigint
#
# Indexes
#
#  index_interpreter_details_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class InterpreterDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
