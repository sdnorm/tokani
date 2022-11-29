# == Schema Information
#
# Table name: interpreter_details
#
#  id               :bigint           not null, primary key
#  gender           :integer
#  interpreter_type :integer
#  primary_phone    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint
#
# Indexes
#
#  index_interpreter_details_on_user_id  (user_id)
#
require "test_helper"

class InterpreterDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
